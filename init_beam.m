function beam = init_beam(opt)

% PARSE OPTIONS
beamsize = opt.beamsize;
nbranch  = opt.nbranch;
horizon  = opt.horizon;
pde      = opt.pde;

beam_queue = cell(1, beamsize);
for i = 1:beamsize
    beam_queue{i}.states   = [];
    beam_queue{i}.features = [];
    beam_queue{i}.actions  = [];
    beam_queue{i}.concat   = [];
    beam_queue{i}.sumlogpd = -inf; % SUM OF LOG PROX. DENSITY
end

beam_queue_branch = cell(1, beamsize*nbranch);
for i = 1:beamsize*nbranch
    beam_queue_branch{i}.states   = [];
    beam_queue_branch{i}.features = [];
    beam_queue_branch{i}.actions  = [];
    beam_queue_branch{i}.concat   = [];
    beam_queue_branch{i}.sumlogpd = -inf; % SUM OF LOG PROX. DENSITY
end

% PARSE OUTPUTS
beam.pde        = pde;
beam.beam_queue = beam_queue;
beam.beam_queue_branch = beam_queue_branch;
beam.beamsize = beamsize;
beam.nbranch  = nbranch;
beam.horizon  = horizon;