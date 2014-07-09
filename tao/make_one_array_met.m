function met=make_one_array_met(fname)
% rearrange processed met data into one matrix
% with continuous time stamp and constant time increment
% from the beginning of first deployment through the
% end of the last deployment
% $Revision: 1.3 $ $Date: 2012/10/22 16:25:17 $ $Author: aperlin $	
% Originally A. Perlin
%
% updated by swarner to reflect new files from NDBC, June 2014

load(fname)
% arrange into one array
fields={'time','uwnd','vwnd','airt','rh',...
    'quality_uwnd','quality_vwnd','quality_airt','quality_rh',...
    'mode_uwnd','mode_vwnd','mode_airt','mode_rh',...
    'depth_wind','depth_airt','depth_rh'};
for jj=1:length(fields)
    temp.(char(fields(jj)))=[];
end
for ii=1:length(met)
    for jj=1:length(fields)
        temp.(char(fields(jj)))=[temp.(char(fields(jj))) met(ii).(char(fields(jj)))'];
    end
end
% delete repeating values
[temp.time ind]=unique(temp.time);
for jj=2:length(fields)-3
    temp.(char(fields(jj)))=temp.(char(fields(jj)))(:,ind);
end
% make continious timestamp with uniform dt
timebase=temp.time(1):round((temp.time(2)-temp.time(1))*24*3600)/24/3600:temp.time(end);
tt.time=timebase;
for jj=2:5
    tt.(char(fields(jj)))=ones(1,length(timebase))*NaN;
end
for jj=6:13
    tt.(char(fields(jj)))=cellstr(repmat('0',length(tt.time),1))';
end
temp.time=round(temp.time*24*3600)/24/3600;
tt.time=round(tt.time*24*3600)/24/3600;
[c,ia,ib]=intersect(tt.time,temp.time);
for jj=2:13
    tt.(char(fields(jj)))(:,ia)=temp.(char(fields(jj)))(:,ib);
end
for jj = 14:16
    tt.(char(fields(jj))) = temp.(char(fields(jj)))(1);
end
tt.readme=met(1).readme;
met=tt;
idot=strfind(fname,'.');
if~isempty(idot)
    idot=idot(end);
    fname=[fname(1:idot-1) '_array'];
else
    fname=[fname '_array'];
end    
save(fname,'met')
