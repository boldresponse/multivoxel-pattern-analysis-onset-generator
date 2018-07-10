% This script will pull trial onset information from a excel-exported
% eprime file (saved as .xls), and will generate EV's for each condition.
% It needs to be modifed for each experiment, as the indicators for
% conditions and the column name that is associated with the trial onset
% will be different from experiment to experiment. Wrote Jan 9, 2014 by Ed
% O'Neil
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



subb=    [1  2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ]
tabb=    [1  2 3 4 5 6 1 2 3  4  5  6  3  4  5  6  1  2  ]
counter= [1  1 1 1 1 1 2 2 2  2  2  2  3  3  3  3  3  3  ]
trial_number = 60 ; %number of trials
problemwrite=0
problemcreate=0 %I have a try loop, this counts how many errors in EV generation (due to no trials satisfying a condition)
for subject=9:18%length(subb)
    for listnum=1:5
        clearvars -except listnum trial_number subb tabb counter subject problemcreate problemwrite sublist*
        subject_num=subb(subject) ;%this is the overall subject number
        tabnum=tabb(subject); %this reflects the counterbalance
        eprimesubnum=counter(subject); %(this changes once we go through a counterbalancing once
        cd /Volumes/EDMACPRO_TIMEMACHINE/Dropbox/projects_current/interferenceMVPA/imaging/InterferenceMVPA/behaviour/xls;
        
        eval(sprintf('subj=''S%dR%d''',subject_num,listnum+7));
        %%%%
        %%%%
        %%%%
        
        
        %%%%
        %%%%
        %%%%
        eval(sprintf('[ndata,tdata,alldata]=xlsread(''shift_REALDEAL_PT2interferenceMVPA_tab%d_list%d-%d-1.xls'')',tabnum,listnum,eprimesubnum));
        %%%%
        %%%%
        %%%%
        
        %make response column, and remove triggers from responses (5's)
        %TAKES 1st RESPONSE IN CASE OF MULTIPLE RESPONSES
        subres = tdata(:,41) ;
        subresx=strcmp(subres,'1{SHIFT}'); sub_resp(subresx)  = 1 ;
        subresx=strcmp(subres,'11{SHIFT}'); sub_resp(subresx)  = 1 ;
        subresx=strcmp(subres,'111'); sub_resp(subresx)  = 1 ;
        subresx=strcmp(subres,'21{SHIFT}'); sub_resp(subresx)  = 2 ;
        subresx=strcmp(subres,'22{SHIFT}'); sub_resp(subresx)  = 2 ;
        subresx=strcmp(subres,'222'); sub_resp(subresx)  = 2 ;
        subresx=strcmp(subres,'12{SHIFT}'); sub_resp(subresx)  = 1 ;
        subresx=strcmp(subres,'2{SHIFT}'); sub_resp(subresx)  = 2 ;
        subresx=strcmp(subres,'{SHIFT}'); sub_resp(subresx)  = NaN ;
        sub_resp=sub_resp(3:62);
        %make condition column
        condition=tdata(3:62,26);%not it skips 2 header rows
        filen=tdata(3:62,28)
        %split condition into type and status - 'face foil' into 'face' and 'foil'
        [stim_type,rem]=strtok(condition,'  ');
        [study_status,rem]=strtok(rem,' ');
        
        %make onset column in seconds
        onset=ndata(:,38); %38th column are onsets
        onset=onset-ndata(1,38); %minus inital start time
        onset=round(onset/1000); %round to second
        onset=onset-(2*3); %cut2vols
        
        % change if you want to write out EV file
        write_out=0; % write EV files? 0=no 1=yes
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Processing of item EVs %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % sort item conditions into EVs
        %these are counters to indicate what entry each value will be in the
        %respective ev files.
        %EV1faceoldc EV2faceoldi EV3facenewc EV4facenewi EV5chairoldc EV6chairoldi EV7chairnewc EV8chairnewi
        a1=1; a2=1; a3=1; a4=1; a5=1;
        
        
        %Set trial lists as empty for each EV
        EV1=[];EV2=[];EV3=[];EV4=[];EV5=[];
        
        
        % populate based on the nature of the Edat file
        %null responses are considered error trials
        for x=1:trial_number
            if regexp('face',stim_type{x})==1;
                if regexp('target',study_status{x})==1;
                    if sub_resp(x)==1; %old
                        EV1(a1)= onset(x); a1=a1+1;
                    elseif sub_resp(x)==2; %new
                        EV5(a5)= onset(x); a5=a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        EV5(a5)= onset(x); a5=a5+1;
                    end
                elseif regexp('foil', study_status{x})==1;
                    if sub_resp(x)==2; %new
                        EV3(a3)= onset(x); a3=a3+1;
                    elseif sub_resp(x)==1; %old
                        EV5(a5)= onset(x); a5=a5+1;
                    elseif isnan(sub_resp(x))==1;; %NR
                        EV5(a5)= onset(x); a5=a5+1;
                    end
                end
                
            elseif regexp('chair',stim_type{x})==1;
                if regexp('target',study_status{x})==1;
                    if sub_resp(x)==1; %old
                        EV2(a2)= onset(x); a2=a2+1;
                    elseif sub_resp(x)==2; %new
                        EV5(a5)= onset(x); a5=a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        EV5(a5)= onset(x); a5=a5+1;
                    end
                elseif regexp('foil', study_status{x})==1;
                    if sub_resp(x)==2; %new
                        EV4(a4)= onset(x); a4=a4+1;
                    elseif sub_resp(x)==1; %old
                        EV5(a5)= onset(x); a5=a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        EV5(a5)= onset(x); a5=a5+1;
                    end
                    
                    
                end
            end
        end
        
        
        
        
        %%%%%%%%%
        %%%%%%%%% SAME CODE AS ABOVE, but making a cells with filenames
        %%%%%%%%%
        
        
        %EV1faceoldc EV2faceoldi EV3facenewc EV4facenewi EV5chairoldc EV6chairoldi EV7chairnewc EV8chairnewi
        name_a1=1; name_a2=1; name_a3=1; name_a4=1; name_a5=1;
        
        
        %Set trial lists as empty for each EV
        name_EV1=[];name_EV2=[];name_EV3=[];name_EV4=[];name_EV5=[];
        
        
        %populate based on the nature of the Edat file
        %null responses are considered error trials
        for x=1:trial_number
            if regexp('face',stim_type{x})==1;
                if regexp('target',study_status{x})==1;
                    if sub_resp(x)==1; %old
                        name_EV1{name_a1}= filen{x}; name_a1=name_a1+1;
                    elseif sub_resp(x)==2; %new
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    end
                elseif regexp('foil', study_status{x})==1;
                    if sub_resp(x)==2; %new
                        name_EV3{name_a3}= filen{x}; name_a3=name_a3+1;
                    elseif sub_resp(x)==1; %old
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    elseif isnan(sub_resp(x))==1;; %NR
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    end
                end
                
            elseif regexp('chair',stim_type{x})==1;
                if regexp('target',study_status{x})==1;
                    if sub_resp(x)==1; %old
                        name_EV2{name_a2}= filen{x}; name_a2=name_a2+1;
                    elseif sub_resp(x)==2; %new
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    end
                elseif regexp('foil', study_status{x})==1;
                    if sub_resp(x)==2; %new
                        name_EV4{name_a4}= filen{x}; name_a4=name_a4+1;
                    elseif sub_resp(x)==1; %old
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    elseif isnan(sub_resp(x))==1; %NR
                        name_EV5{name_a5}= filen{x}; name_a5=name_a5+1;
                    end
                    
                    
                end
            end
        end
        
        
        %%%%%%
        %%%%%%
        %%%%%%
        %Create a 3 column matrix with the duration and weight information (here,
        %duration is hard-coded)
        for xx=1:5
            try
                eval(sprintf('ev%dmtx(:,1)=(EV%d)',xx,xx));
                eval(sprintf('ev%dmtx(:,2)=3',xx));
                eval(sprintf('ev%dmtx(:,3)=1',xx));
            catch
                warning('Problem using function.  Assigning a value of 0.');
                problemcreate=problemcreate+1
            end
        end
        
        %cut below 0s onsets
        if isempty(ev1mtx)==0;
            if ev1mtx(1,1)<0;
                ev1mtx(1,:)=[]
            end
        end
        if isempty(ev2mtx)==0
            if ev2mtx(1,1)<0;
                ev2mtx(1,:)=[]
            end
        end
        if isempty(ev3mtx)==0
            if ev3mtx(1,1)<0;
                ev3mtx(1,:)=[]
            end
        end
        if isempty(ev4mtx)==0
            if ev4mtx(1,1)<0;
                ev4mtx(1,:)=[]
            end
        end
        if isempty(ev5mtx)==0
            if ev5mtx(1,1)<0;
                ev5mtx(1,:)=[]
            end
        end
        
        
        
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        %%%%%%
        %%%%%%
        %%%%%%
        %Same as above, but cells to add 4th column of filenames
        %cut below 0s onsets
        for xx=1:5
            try
                eval(sprintf('name_ev%dmtx=[num2cell(EV%d);name_EV%d]',xx,xx,xx));
                % eval(sprintf('name_ev%dmtx{:,2}=3',xx));
                % eval(sprintf('name_ev%dmtx{:,3}=1',xx));
                
            catch
                warning('Problem using function.  Assigning a value of 0.');
                problemcreate=problemcreate+1
            end
        end
        
        if isempty(name_ev1mtx)==0;
            if name_ev1mtx{1,1}(1)<0;
                name_ev1mtx(:,1)=[]
            end
        end
        if isempty(name_ev2mtx)==0
            if name_ev2mtx{1,1}(1)<0;
                name_ev2mtx(:,1)=[]
            end
        end
        if isempty(name_ev3mtx)==0
            if name_ev3mtx{1,1}(1)<0;
                name_ev3mtx(:,1)=[]
            end
        end
        if isempty(name_ev4mtx)==0
            if name_ev4mtx{1,1}(1)<0;
                name_ev4mtx(:,1)=[]
            end
        end
        if isempty(name_ev5mtx)==0
            if name_ev5mtx{1,1}(1)<0;
                name_ev5mtx(:,1)=[]
            end
        end
        
        
        
        
        
        %%%%%%%
        %%%%%%%
        %%%%%%%
        %Transpose and add third column with conditon type
        for yy=1:5
            eval(sprintf('name_ev%dmtx=name_ev%dmtx''',yy,yy))
            eval(sprintf('[name_ev%dmtx{:,3}]=deal(yy)',yy))
            eval(sprintf('[name_ev%dmtx{:,4}]=deal(listnum+7)',yy))
            
        end
        
        eval(sprintf('sublist%s=[name_ev1mtx; name_ev2mtx; name_ev3mtx; name_ev4mtx; name_ev5mtx]',subj))
        
    end
    eval(sprintf('sublist%d=[sublistS%dR8; sublistS%dR9; sublistS%dR10; sublistS%dR11; sublistS%dR12]',subject,subject,subject,subject,subject,subject))
    
end

for zzz=9:18
   eval(sprintf('slst(zzz,:,:)=sublist%d',zzz))
end