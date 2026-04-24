% Coherent motion experiment
% author: dan norton april/may 2009
% updated: michaela lewis june 2011
% updated: dawson miller april 2026 (MacOS)


%% ================= Initialization ===================
clear all;
warning('off','MATLAB:dispatcher:InexactCaseMatch');
clc;
Screen('CloseAll');
wptr = 0;
KbName('UnifyKeyNames');
format short g

%% ================ Subject Information and param GUI===============
prompt = {'SUBJECT ID', 'Repetitions', 'Threshold', 'Lock on eye?'};
defaults = {' ', '1', ' 1 ','0'};
answer = inputdlg(prompt,'EXPERIMENT SETUP',1,defaults);
[sub_idstring repetitionstring speedthreshstring eyelockstr]= deal(answer{:});
eyelock = str2double(eyelockstr);
repetitions = str2double(repetitionstring);
speedthresh = str2double(speedthreshstring);
fieldsize = 27.7733344 * 10;
sub_id = sub_idstring;
pixelsperdegree = 27.7733344;

% %% ========== set up paralell port to write XDAT values ================
%  dio = digitalio('parallel','LPT1');
%  in_lines = addline(dio, 0:7, 0, 'out');
%  xdatmarker = [0 0 0 0 0 0 0 0];
%  putvalue(dio.Line(1:8),xdatmarker) % should be a vector of 0's and 1's
 %% Create Automation server

% s = actxserver('ASLSerialOutLib2.ASLSerialOutPort3');
% configFile = strcat(pwd, '\EyeTrac6_stream.xml');
% port = 1;
% eyeHeadIntegration = 0;
% [baudRate,updateRate,streamingMode,itemCount,itemNames] = ...
%     invoke(s, 'Connect', configFile, port, eyeHeadIntegration);

   %% ================ Response Keys ============================
KbName('UnifyKeyNames');
codD(1) = KbName('y');
codD(2) = KbName('n');

    %% open the screen
    AssertOpenGL;
    doublebuffer=1;
	screenNumber=max(Screen('Screens'));
    [w, rect] = Screen('OpenWindow', screenNumber, 50,[], 32, doublebuffer+1);
    [width, height]=Screen('WindowSize', w); % the crosshair
    Hz = Screen('FrameRate', w);
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [center(1), center(2)] = RectCenter(rect);
	 fps=Screen('FrameRate',w);      % frames per second
    ifi=Screen('GetFlipInterval', w);
    if fps==0
       fps=1/ifi;
    end

    black = BlackIndex(w);
    white = WhiteIndex(w);
    HideCursor(w);	% Hide the mouse cursor
    Priority(MaxPriority(w));

    % Do initial flip...
    vbl=Screen('Flip', w);

    %% conditions matrix
speedmat = [.6 1.2 2.4]*60/144;%speedthresh;yynynyn
idx = 0;
cond = zeros((length(speedmat)*12),4);
for speed = speedmat(1,:)
    for targetlocation = 1:12
    %for probematchestarget = -1:2:1;
    %for movingornot = [1];
            for rep = 1:repetitions
            idx = idx+1;
            coin = rand;
     if coin > .5
     probematchestarget = 0;
     elseif coin <= .5
        probematchestarget = 1;
    end
            cond(idx,:) = [speed, probematchestarget, targetlocation, rep];
            end
    %end
    %end
    end
end
% % make the 16 stationary trials:
% cond2 = zeros(16,5);
% movingornot = 0;
 itt = 0;
%  for targetlocation = 1:12; % in the good old days, this was set to 16.  now it's only 12 because i got rid of the 4 dummy conditions of sitll dots. we'll still have them, but they'll be set at 0 speed along with 3 other speeds, bitches!!!!!!!!!!!!!%we use these locations because it corresponds to 4 opposite-hemifield and 4 same-hemifield.
%      coin = rand;
%      if coin > .5,
%      probematchestarget = 0;
%      elseif coin <= .5
%         probematchestarget = 1;
%     end
%         itt = itt+1;
%         cond2(itt,:) = [speed, probematchestarget, targetlocation, 0;
% end
% note this also sets the "rep number" for each stationary trial to 0,
% since the 16 trials are not associated with any given repetition.

%cond = [cond1;cond2];
trial = (Shuffle(1:size(cond,1)))';
cond = [trial cond];
cond = sortrows(cond);
trialnumber = size(cond,1);
totaltime = 248; % number of frames we need to record eye data for in this task.
%all_eyecoords = zeros(2,totaltime,trialnumber);


    %% POST-CALIBRATION CENTER CHECK
%             if eyelock == 1
%             xcent = zeros(1,30);
%             ycent = zeros(1,30);
%
%             instruc1 = 'Stare into the very heart of the fixation cross!';
%             Screen('DrawLine', w, 150, width/2 - 6, height/2, width/2 + 6, height/2,2);
%             Screen('DrawLine', w, 150, width/2, height/2-6, width/2, height/2+6, 2);
%             DrawFormattedText(w, instruc1, 'center', 200, [255,255,255]);
%             Screen('Flip', w);
%             KbWait;
%
%             %Upon keypress, record the position of subject's eyes for a quarter second:
%             for i = 1:30
%                 Screen('DrawLine', w, 150, width/2 - 6, height/2, width/2 +6, height/2,2);
%                 Screen('DrawLine', w, 150, width/2, height/2-6, width/2, height/2+6, 2);
%                 Screen('Flip', w);
%                 msg = s.GetScaledData;
%                 xcent(i) = msg{4};
%                 ycent(i) = msg{5};
%             end
%
%             Screen('DrawLine', w, 150, width/2 - 6, height/2, width/2 +6, height/2,2);
%             Screen('DrawLine', w, 150, width/2, height/2-6, width/2, height/2+6, 2);
%             Screen('Flip', w);
%
%             xcenter = median(xcent);
%             ycenter = median(ycent);
%             % But if this value is crappy:
%             if (~(xcenter > 100 && xcenter < 200)) || (~(ycenter > 100 && ycenter < 200))
%             xcenter = 135;
%             ycenter = 135;
%             end
%             else
%             xcenter = 135;
%             ycenter = 135;
%             %Upon keypress, put back to grey and begin actual trials
%             WaitSecs(2);
%             end

%% center dots

for n = 1:trialnumber

%xdatmarker = bitget(cond(n,1),1:1:8);
%%%putvalue(dio.Line(1:8),xdatmarker)  % Tell eye tracker what trial we're on
%%
coin = round(rand(1,1))


 %% ============== initial ball positions ====================

speed = cond(n,2);%150; % the smaller the faster
pairoffsetmat = [1024*.2 -768*.2;
                 -1024*.2 -768*.2;
                 -1024*.2 768*.2;
                 1024*.2 768*.2];
 % first pair
dice = rand(1,1).*2*pi;
posmat1a = [sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
posmat1b = [-sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); -cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
horizontalshift = [ones(1,length(posmat1a)); zeros(1,length(posmat1a))].*pairoffsetmat(1,1);
verticalshift = [zeros(1,length(posmat1a)); ones(1,length(posmat1a))].*pairoffsetmat(1,2);
posmat1a = posmat1a.*50 + horizontalshift + verticalshift;
posmat1b = posmat1b.*50 + horizontalshift + verticalshift;

% % second pair
dice = rand(1,1).*2*pi;
posmat2a = [sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
posmat2b = [-sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); -cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
horizontalshift = [ones(1,length(posmat1a)); zeros(1,length(posmat1a))].*pairoffsetmat(2,1);
verticalshift = [zeros(1,length(posmat1a)); ones(1,length(posmat1a))].*pairoffsetmat(2,2);
posmat2a = posmat2a.*50 + horizontalshift + verticalshift;
posmat2b = posmat2b.*50 + horizontalshift + verticalshift;
%
% % third pair
dice = rand(1,1).*2*pi;
posmat3a = [sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
posmat3b = [-sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); -cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
horizontalshift = [ones(1,length(posmat1a)); zeros(1,length(posmat1a))].*pairoffsetmat(3,1);
verticalshift = [zeros(1,length(posmat1a)); ones(1,length(posmat1a))].*pairoffsetmat(3,2);
posmat3a = posmat3a.*50 + horizontalshift + verticalshift;
posmat3b = posmat3b.*50 + horizontalshift + verticalshift;
%
% % fourth pair
dice = rand(1,1).*2*pi;
posmat4a = [sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
posmat4b = [-sin(dice + 0:speed.*(1/120)*2*pi:500 + dice); -cos(dice + 0:speed.*(1/120)*2*pi:500+ dice)];
horizontalshift = [ones(1,length(posmat1a)); zeros(1,length(posmat1a))].*pairoffsetmat(4,1);
verticalshift = [zeros(1,length(posmat1a)); ones(1,length(posmat1a))].*pairoffsetmat(4,2);
posmat4a = posmat4a.*50 + horizontalshift + verticalshift;
posmat4b = posmat4b.*50 + horizontalshift + verticalshift;

%% ===================Probe selection==========================
targets = randi([1,4],1,2); % selects 2 numbers from 1 to 4
 if cond(n,3) == 0
    probe = targets(1,1);
 end;
%% =============sliding windows =====================

% FIRST WINDOW --------------------------------------
middlea = round((length(posmat1a)/2));
ba = (middlea-round(Hz/8):middlea+round(Hz/8));
qa = 1:length(ba);
ca = ba;

for i = 1:75 % 75 is an arbitrary number, it's just enough sliding
              % windows to last however long you want to show the dots
    coina = rand(1,1);
    if coina <=0.5;
        ba = ba(1,length(ba)) - qa;
    else
    	ba =ba(1,length(ba)) + qa;
    end;
    ca = cat(1,ca,ba);
end;

ca = reshape((fliplr(rot90(ca,3))), 1, numel(ca));

% SECOND WINDOW  --------------------------------------

middleb = round((length(posmat2a)/2));
bb = (middleb-round(Hz/8):middleb+round(Hz/8));
qb = 1:length(bb);
cb = bb;

for i = 1:75
    coinb = rand(1,1);
    if coinb <=0.5;
        bb = bb(1,length(bb)) - qb;
    else
        bb =bb(1,length(bb)) + qb;
    end;
    cb = cat(1,cb,bb);
end;
cb = reshape((fliplr(rot90(cb,3))), 1, numel(cb));

% THIRD WINDOW --------------------------------------

middlec = round((length(posmat3a)/2));
bc = (middlec-round(Hz/8):middlec+round(Hz/8));
qc = 1:length(bc);
cc = bc;

for i = 1:75
    coinc = rand(1,1);
    if coinc <=0.5;
        bc = bc(1,length(bc)) - qc;
    else
        bc =bc(1,length(bc)) + qc;
    end;
    cc = cat(1,cc,bc);
end;
cc = reshape((fliplr(rot90(cc,3))), 1, numel(cc));

% FOURTH WINDOW --------------------------------------

middled = round((length(posmat4a)/2));
bd = (middled-round(Hz/8):middled+round(Hz/8));
qd = 1:length(bd);
cd = bd;

for i = 1:75
    coind = rand(1,1);
    if coind <=0.5;
        bd = bd(1,length(bd)) - qd;
    else
        bd =bd(1,length(bd)) + qd;
    end;
    cd = cat(1,cd,bd);
end;
cd = reshape((fliplr(rot90(cd,3))), 1, numel(cd));

%% ============color assignments====================
 j=0;
 presentationtime = 8;
 red = [255 0 0];
 green = [0 255 0];
 targetcolormat = [0 0 255];

 target1a = red;
 distractor1a = red;
 target2a = red;
 distractor2a = red;
  target3a = red;
 distractor3a = red;
  target4a = red;
 distractor4a = red;

 target1b = red;
 distractor1b = red;
 target2b = red;
 distractor2b = red;
  target3b = red;
 distractor3b = red;
  target4b = red;
 distractor4b = red;

 % ================== determining probe (distractor or target) ==========
 if cond(n,3) == 0
     targetcolor = red;
     distractorcolor = green;
 elseif cond(n,3) == 1
     targetcolor = green;
     distractorcolor = red;
 end;

 % ================= determining targets ================================

if cond(n,4) == 1
     target1a = green;
     target2a = green;
     target1b = targetcolor;
     distractor1b = distractorcolor;

elseif cond(n,4) == 2
     target1a = green;
     target3a = green;
     target1b = targetcolor;
     distractor1b = distractorcolor;

elseif cond(n,4) == 3
     target1a = green;
     target4a = green;
     target1b = targetcolor;
     distractor1b = distractorcolor;

elseif cond(n,4) == 4
     target2a = green;
     target1a = green;
     target2b = targetcolor;
     distractor2b = distractorcolor;

elseif cond(n,4) == 5
     target2a = green;
     target3a = green;
     target2b = targetcolor;
     distractor2b = distractorcolor;

elseif cond(n,4) == 6
     target2a = green;
     target4a = green;
     target2b = targetcolor;
     distractor2b = distractorcolor;

elseif cond(n,4) == 7
     target3a = green;
     target1a = green;
     target3b = targetcolor;
     distractor3b = distractorcolor;

elseif cond(n,4) == 8
     target3a = green;
     target2a = green;
     target3b = targetcolor;
     distractor3b = distractorcolor;

elseif cond(n,4) == 9
     target3a = green;
     target4a = green;
     target3b = targetcolor;
     distractor3b = distractorcolor;

elseif cond(n,4) == 10
     target4a = green;
     target1a = green;
     target4b = targetcolor;
     distractor4b = distractorcolor;

elseif cond(n,4) == 11
     target4a = green;
     target2a = green;
     target4b = targetcolor;
     distractor4b = distractorcolor;

elseif cond(n,4) == 12
     target4a = green;
     target3a = green;
     target4b = targetcolor;
     distractor4b = distractorcolor;

elseif cond(n,4) == 13 %(same as condition 3)
     target1a = green;
     target4a = green;
     target1b = targetcolor;
     distractor1b = distractorcolor;

elseif cond(n,4) == 14  %(same as condition 5)
     target2a = green;
     target3a = green;
     target2b = targetcolor;
     distractor2b = distractorcolor;

elseif cond(n,4) == 15  %(same as condition 8)
     target3a = green;
     target2a = green;
     target3b = targetcolor;
     distractor3b = distractorcolor;

elseif cond(n,4) == 16  %(same as condition 10)
     target4a = green;
     target1a = green;
     target4b = targetcolor;
     distractor4b = distractorcolor;
end
 %% ===================presentation=============================
 xcoords = zeros(1,248);
 ycoords = zeros(1,248);

    for i = 1:round(30/60*144)
        Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
        Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
        Screen('Flip', w);
    end

      starT=GetSecs;
 %===================firsttime=============================

 z = 0;
 i = 1;
 p = 1;
 k = 1;
 u = 1;

    while z <= 120/60*144
        Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
        Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
            if z == 0
                i = randi(4*length(ba));
                p = randi(4*length(ba));
                k = randi(4*length(ba));
                u = randi(4*length(ba));
            end
        Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, target1a, center, 1);
        Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, distractor1a, center, 1);

        Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, target2a, center, 1);
        Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, distractor2a, center, 1);

        Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, target3a, center, 1);
        Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3a, center, 1);

        Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, target4a, center, 1);
        Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4a, center, 1);

        Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        vbl=Screen('Flip', w);


        z=z+1;
    end;

   % =====================secondtime  ===============================

z=1;
    while z <= 248/60*144
    % Draw fixation cross:
        Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
        Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

        Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, red, center, 1);
        Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, red, center, 1);

        Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, red, center, 1);
        Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, red, center, 1);

        Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, red, center, 1);
        Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, red, center, 1);

        Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, red, center, 1);
        Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, red, center, 1);

        Screen('DrawingFinished', w);
        vbl=Screen('Flip', w);
%          msg = s.GetScaledData;
%          xcoords(1,z) = msg{4};
%          ycoords(1,z) = msg{5};

        z=z+1;
%         if cond(n,6) == 1
            i = i+1;
            p = p+1;
            k = k+1;
            u = u+1;
%         end
    end

   % ========================thirdtime===================
 z = 0;
    while z <= 90/60*144

    % Draw fixation cross:
        Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
        Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

        Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, target1b, center, 1);
        Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, distractor1b, center, 1);

        Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, target2b, center, 1);
        Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, distractor2b, center, 1);

        Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, target3b, center, 1);
        Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3b, center, 1);

        Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, target4b, center, 1);
        Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4b, center, 1);

        Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        vbl=Screen('Flip', w);


        z=z+1;
    end

    %eyecoords = [xcoords;ycoords];
% final flip:
Screen('Flip',w);

        %% Get Response
        done = 0;
        noW = 0;

        while(~done)
            [eKey secs kCod] = KbCheck;
            if kCod(codD(1)) || kCod(codD(2)) ~= 0
                done = 1;
                noW = secs;
                cond(n,7) = find(kCod ~= 0);
                cond(n,8) = noW - starT;
            end
        end


          %% Check correct response
        if (cond(n,3) == 0) && (cond(n,7) == 17)
            cond(n,9) = 1; % correct (left)
        elseif (cond(n,3) == 1) && (cond(n,7) == 30)
            cond(n,9) = 1; % correct (right)
        else
            cond(n,9) = 0;
        end

        %cond(n,5)= str2double(sub_id);
% xcoordmax = max(xcoords);
% xcoordmin = min(xcoords);
%
% cond(n,9) = xcoordmin;
% cond(n,10) = xcoordmax;
% if cond(n,9) < 129.5 - 12.95
%     cond(n,11) = 0;
% elseif cond(n,10) > 129.5 +12.95
%     cond(n,11) = 0;
% else cond(n,11) = 1;
% end;

  WaitSecs(1);
%% save eye coordinates:
%all_eyecoords(:,:,n) = eyecoords;
end
% In columns 10 and 11 of cond, I saved the median center point from which the
% throwout_trials vector in column 12 is calculated.

% cond(:,10) = xcenter;
% cond(:,11) = ycenter;
% cond(:,12) = checker(all_eyecoords, xcenter, ycenter, totaltime);
%
% % Close the connection
% s.Disconnect
%
% % Release the memory
% s.delete

 Priority(0);
    ShowCursor
    Screen('CloseAll');

    cond = cond(1:trialnumber,:);

%% ===================== Draw Graph etc ===========================

% Calculate mean accuracy on the staionary trials:
stat_trials = cond(cond(:,6)==0,:);
stat_acc = mean(stat_trials(:,9)) ;

% Calculate mean accuracy on the moving trials:
mov_trials = cond(cond(:,6)~=0,:);
mov_acc = mean(mov_trials(:,9)) ;

% Calculate mean accuracy on all of the left hemifield trials:
left_trials = cond((cond(:,4)==4) | (cond(:,4)==5) | (cond(:,4)==6) | (cond(:,4)==7) | (cond(:,4)==8) | (cond(:,4)==9) | (cond(:,4)==14) | (cond(:,4)==15),:);
left_acc = mean(left_trials(:,9));

% Calculate mean accuracy on all of the right hemifield trials:
right_trials = cond((cond(:,4)==1) | (cond(:,4)==2) | (cond(:,4)==3) | (cond(:,4)==10) | (cond(:,4)==11) | (cond(:,4)==12) | (cond(:,4)==13) | (cond(:,4)==16),:);
right_acc = mean(right_trials(:,9));

% Calculate mean accuracy on all of the trials where the targets were in
% the same hemifield:
same_hemi_trials = cond((cond(:,4)==3) | (cond(:,4)==5) | (cond(:,4)==8) | (cond(:,4)==10) | (cond(:,4)==13) | (cond(:,4)==14) | (cond(:,4)==15) | (cond(:,4)==16),:);
same_hemi_acc = mean(same_hemi_trials(:,9));

% Calculate mean accuracy on all of the trials where the targets were in
% opposite hemifields:
opp_hemi_trials = cond((cond(:,4)==1) | (cond(:,4)==2) | (cond(:,4)==4) | (cond(:,4)==6) | (cond(:,4)==7) | (cond(:,4)==9) | (cond(:,4)==11) | (cond(:,4)==12),:);
opp_hemi_acc = mean(opp_hemi_trials(:,9));

% Plot these accuracies on a bar graph!

% figure;
% bar([1 2 3 4 5 6],[mov_acc stat_acc 0 0 0 0],'r');
% axis([0 7 0 1]);
% grid on
% hold on
% bar([3 4],[left_acc right_acc],'b');
% grid on
% hold on
% bar([5 6], [same_hemi_acc opp_hemi_acc],'k');
% grid on
% hold on
% set(gca,'XTickLabel',{'Moving', 'Stationary', 'Left', 'Right', 'Same', 'Opposite'});
%
% title('Accuracy ');
% xlabel('Condition');
% ylabel('Accuracy(%)');


%% ================= Write Data =====================

% ============================================================
% USER CONFIGURATION REQUIRED: CHANGE DIRECTORY BELOW
% ============================================================
path = ; % <------ ||IMPORTANT|| ENTER SAVE PATHWAY HERE
subid_str = strtrim(sub_idstring);
t = datevec(now);
timer = strcat(num2str(t(1)),'_',num2str(t(2)),'_',num2str(t(3)),'_',num2str(t(4)),'_',num2str(t(5)));
filename = [path subid_str '_MOT_cond_' timer]; % Creates a matrix of usable data

% Make sure the folder exists
if ~exist(path, 'dir')
    mkdir(path);
end

% Save everything
save([filename '.mat']);
% Automatically save cond matrix as CSV
csvwrite([filename '.csv'], cond);

% if eyelock == 1
%     eyeposgraph(all_eyecoords); %open separate figure of eye position data.
%     saveas(gcf, [path 'Eye Data\' subid_str '_MOT_2targ_EYEDATA_' timer '.fig']) % save eye data figure
% end

