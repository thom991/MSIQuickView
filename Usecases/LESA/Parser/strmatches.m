function idx = strmatches(str,strarray,opt)
% STRMATCHES  Find matches of a string with an array of strings
%   idx = strmatches(str,strarrary,opt)
% Input
%   str          candidate string
%   strarrary    character arrary or cell array of strings
%   opt          'first' or 'last' or [] (default)
%                'first' returns the index of the first matching string
%                'last'  returns the index of the last  matching string
% Output
%   idx          array of index locations of matching strings from strarray
%
%  This function is a replacement for strmatch.

% Copyright 2012, North Carolina State University
% Written by Ken Garrard

% need at least two non-empty arguments
if nargin < 2, return; end
if isempty(str) || isempty(strarray), idx = []; return; end;

% find matches
idx = find(strncmpi(str,strarray,length(str))==1);
idx = idx(:);

% return now if str is not in strarray
if isempty(idx), return; end

% process options
if nargin > 2
   if     strcmpi(opt,'first'), idx = idx(1);
   elseif strcmpi(opt,'last'),  idx = idx(end);
   end
end
