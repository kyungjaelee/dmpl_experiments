function beam = beam_search(beam, inits, mdp_data, s2f)

% PARSE OPTIONS
beamsize = beam.beamsize;
nbranch  = beam.nbranch; % THIS IS EQUIVALENT TO THE NUMBER OF ACTINOS
horizon  = beam.horizon;
pde      = beam.pde;

% PARSE MDP INFORMATION
na = mdp_data.actions;
ns = mdp_data.states;
sa_s = mdp_data.sa_s;
sa_p = mdp_data.sa_p;

% BEAM QUEUE AND BRANCH QUEUE
beam_queue = beam.beam_queue;
beam_queue_branch = beam.beam_queue_branch;

% FOR THE FIRST TICK, 
% FILL IN THE 'BEAM_QUEUE' & 'BEAM_QUEUE_BRANCH'
for aidx = 1:na % FOR ALL ACTIONS
    avec = zeros(1, na); avec(aidx) = 1; cfeat = s2f(inits, :);
    concatfeat = [cfeat, avec];
    logpd = log(get_pde(pde, concatfeat)+eps);
    % ADD TO QUEUE_BRANCH
    beam_queue_branch{aidx}.states   = [inits];
    beam_queue_branch{aidx}.features = [s2f(inits, :)];
    beam_queue_branch{aidx}.actions  = [aidx];
    beam_queue_branch{aidx}.concat   = [concatfeat];
    beam_queue_branch{aidx}.sumlogpd = [logpd];
     % ADD TO QUEUE
    beam_queue{aidx}.states   = [inits];
    beam_queue{aidx}.features = [s2f(inits, :)];
    beam_queue{aidx}.actions  = [aidx];
    beam_queue{aidx}.concat   = [concatfeat];
    beam_queue{aidx}.sumlogpd = [logpd];
end

% FROM THE SECOND TICK
for tick = 2:horizon % FOR ALL HORIZON
    
    % 1. INDEX FOR BEAM QUEBRANCH INDEX
    bqb_idx = 0;
    for qidx = 1:length(beam_queue) % FOR EACH BEAM_QUEUE
        cbq = beam_queue{qidx};
        if isinf(cbq.sumlogpd), continue; end;
        % 1. GET LAST STATE AND ACTION
        a = 1;
        last_s = cbq.states(end, :);
        last_a = cbq.actions(end, :);
        aprobs = squeeze(sa_p(last_s, last_a, :))';
        [~, maxaidx] = max(aprobs);
        % 2. COMPUTE MOST PROBABLE NEXT STATE
        next_s = sa_s(last_s, last_a, maxaidx);
        next_f = s2f(next_s, :);
        % 3. FOR ALL POSSSIBLE ACTIONS
        for aidx = 1:na % FOR ALL ACTIONS
            avec = zeros(1, na); avec(aidx) = 1;
            concatfeat = [next_f, avec];
            logpd = log(get_pde(pde, concatfeat)+eps);
            % ADD TO BEAM QUEUE BRANCE
            bqb_idx = bqb_idx + 1;
            % CONCATENATE STATE / FEATURE / ACTIONS / CONCAT
            beam_queue_branch{bqb_idx}.states = [cbq.states ; next_s];
            beam_queue_branch{bqb_idx}.features = [cbq.features ; next_f];
            beam_queue_branch{bqb_idx}.actions = [cbq.actions ; aidx];
            beam_queue_branch{bqb_idx}.concat = [cbq.concat ; concatfeat];
            beam_queue_branch{bqb_idx}.sumlogpd = [cbq.sumlogpd ; logpd];
        end
    end
    
    % 2. SELECT TOP-K BRANCHES FROM BEAM QUEUE BRANCE
    sumlogpd_list = zeros(bqb_idx, 1);
    for qidx = 1:bqb_idx
        sumlogpd_list(qidx) = sum(beam_queue_branch{qidx}.sumlogpd);
    end
    [~, sortedidx] = sort(sumlogpd_list, 'descend');
    topk_list = sortedidx(1:min(end, beamsize));
    for bqidx = 1:length(topk_list)
        beam_queue{bqidx} = beam_queue_branch{topk_list(bqidx)};
    end
end

% FIND THE OPTIMAL BEAM
pds = zeros(1, length(beam_queue));
for bqidx = 1:length(beam_queue)
    pds(bqidx) = beam_queue{bqidx}.sumlogpd;
end
[~, maxidx] = max(pds);
optimal_action = beam_queue{maxidx}.actions(1);

% PARSE OUTPUT
beam.beam_queue = beam_queue;
beam.beam_queue_branch = beam_queue_branch;
beam.optimal_action = optimal_action;


