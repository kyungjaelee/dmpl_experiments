function nzr_x = init_nz(data, eps)

if nargin == 1
    eps = 0;
end

% Init normalizer
nzr_x.mu   = mean(data);
nzr_x.sig  = std(data);
nzr_x.eps  = eps;
% nzr_x.org_data = data;

zerodix = find(nzr_x.sig < 0.1);
if isempty(zerodix) == 0    
    % disp(zerodix);
    nzr_x.sig(zerodix) = 1;
end

% nzr_x.data = get_nzval(nzr_x, data);

% temp = get_orgval(nzr_x, nzr_x.data);
% nzr_x.reconerr = norm(data - temp);
