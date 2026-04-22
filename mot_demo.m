% Coherent motion experiment
% author: dan norton april/may 2009
%% ================= Initialization ===================
clear all;
warning('off','MATLAB:dispatcher:InexactCaseMatch');
clc;
Screen('CloseAll');
wptr = 0;
KbName('UnifyKeyNames');
format short g
%% ========== set up paralell port to write XDAT values ================
%  dio = digitalio('parallel','LPT1');
%  in_lines = addline(dio, 0:7, 0, 'out');
%  xdatmarker = [0 0 0 0 0 0 0 0];
%  putvalue(dio.Line(1:8),xdatmarker) % should be a vector of 0's and 1's
 %% Create Automation server
%
% s = actxserver('ASLSerialOutLib2.ASLSerialOutPort3');
% configFile = strcat(pwd, '\EyeTrac6_stream.xml');
% port = 1;
% eyeHeadIntegration = 0;
% [baudRate,updateRate,streamingMode,itemCount,itemNames] = ...
%     invoke(s, 'Connect', configFile, port, eyeHeadIntegration);
%% ================ Subject Information and param GUI===============
% prompt = {'SUBJECT ID', 'Repetitions', 'Threshold'};
% defaults = {' ', '1', '1'};
% answer = inputdlg(prompt,'EXPERIMENT SETUP',1,defaults);
% [sub_idstring repetitionstring speedthreshstring]= deal(answer{:});

repetitions = 1;
speedthresh = .5%3;
fieldsize = 27.7733344 * 10;
% sub_id = sub_idstring;
pixelsperdegree = 27.7733344;
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
    HideCursor;	% Hide the mouse cursor
    Priority(MaxPriority(w));

    % Do initial flip...
    vbl=Screen('Flip', w);

    %% conditions matrix
speedmat = speedthresh;
idx = 0;
cond = zeros((length(speedmat)*repetitions*2*16),4);
for speed = speedmat(1,:);
    for targetlocation = 1:16;
    for probematchestarget = -1:2:1;
            for rep = 1:repetitions;
            idx = idx+1;
            cond(idx,:) = [speed, probematchestarget, targetlocation, rep];
            end
    end
    end
end

%trial = Shuffle(1:length(cond))';
trial = (Shuffle(1:size(cond,1)))';
cond = [trial cond];
cond = sortrows(cond);
trialnumber = size(cond,1);

%% center dots
demolength = 2;
for n = 1:demolength;

xcoords = [];
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
 if cond(n,3) == -1
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
 green = [0 0 255];
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
 if cond(n,3) == -1
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

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                                   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%             BEGIN DEMO            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                                   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ================== DEMO INSTRUCTIONS =======================

instruc0 = 'During the work, make sure to keep your eyes fixed on the crosshair';% DONE
instruc1 = 'You will see 4 pairs of separated circles.';% DONE
%show all 4 pairs of circles (unmoving) then KbWait.
instruc2 = 'Before each trial, I will highlight TWO circles in green. \n\n (In the demo it is blue)'; % DONE
%highlight 2 of the circles in green (all unmoving). wait2s, point little arrows to them one by one...then KbWait.
instruc3 = 'After a moment, all the circles will turn red again. \n\n Remember to follow the circles that I highlighted. \n\n FOCUS ON THE CROSSHAIR';
% KbWait, then start moving the circles. Highlight probes.
instruc4 = 'Is this blue circle one of the two circles you were following? \n\n Press y for yes or n for no.';
% get response. begin real trials. point arrows to both green ones ( @ the
% same time) before starting for the first 5 trials.

% =================== DEMO PRESENTATION =======================

if n == 1
    starT=GetSecs;
% ------------------------- instruc0: ----------------------- %
    DrawFormattedText(w, instruc0, 'center', 50, [255,255,255]);
    Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
    Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
    Screen('Flip',w);
    KbWait;

% ------------------------- instruc1: ------------------------ %
    DrawFormattedText(w, instruc1, 'center', 50, [255,255,255]);
    Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
    Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
    Screen('Flip',w);
    WaitSecs(0.3)
    KbWait;

% ------------------- Draw unmoving red circles: -------------------

    DrawFormattedText(w, instruc1, 'center', 50, [255,255,255]);
    Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
    Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
            i = randi(4*length(ba));
            p = randi(4*length(ba));
            k = randi(4*length(ba));
            u = randi(4*length(ba));
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
    WaitSecs(0.3)

    KbWait;

% ------------------------- instruc2: ------------------------ %
%---------- Draw unmoving red circles w/green highlights: ------------%

    DrawFormattedText(w, instruc2, 'center', 50, [255,255,255]);
    Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
    Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

    Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, target1a, center, 1);
    Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, distractor1a, center, 1);

    Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, target2a, center, 1);
    Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, distractor2a, center, 1);

    Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, target3a, center, 1);
    Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3a, center, 1);

    Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, target4a, center, 1);
    Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4a, center, 1);

    Screen('DrawingFinished', w);
    vbl=Screen('Flip', w);
%     msg = s.GetScaledData;
%     xcoords = cat(1,xcoords,msg(4,1));
    WaitSecs(1.5);

    % ------------- Draw arrow to green circle #1: -------------------%

                already = 0; % so that I know which green circle I already drew an arrow to.
                if target1a==green
                    initball = posmat1a(:,ca(1,length(ba)),1);
                    already = 1;
                elseif target2a==green
                    initball = posmat2a(:,ca(1,p),1);
                    already = 2;
                elseif target3a==green
                    initball = posmat3a(:,ca(1,k),1);
                    already = 3;
                elseif target4a==green
                    initball = posmat4a(:,ca(1,u),1)
                    already = 4;
                end

                initballx = (initball(1)+center(1))-11;
                initbally = (initball(2)+center(2))-11;

                Screen('DrawLine', w, [255,255,255], (initballx-40), (initbally-40), (initballx), (initbally), 2);
                Screen('DrawLine', w, [255,255,255], (initballx), (initbally-14), (initballx), (initbally), 2);
                Screen('DrawLine', w, [255,255,255], (initballx-14), (initbally), (initballx), (initbally), 2);

                %As well as drawing all the balls and the instruc2:
                DrawFormattedText(w, instruc2, 'center', 50, [255,255,255]);
                Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
                Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

                Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, target1a, center, 1);
                Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, distractor1a, center, 1);

                Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, target2a, center, 1);
                Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, distractor2a, center, 1);

                Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, target3a, center, 1);
                Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3a, center, 1);

                Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, target4a, center, 1);
                Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4a, center, 1);

                Screen('DrawingFinished', w);
                Screen('Flip', w);
                WaitSecs(1);

    % ------------- Draw arrow to green circle #2: -------------------%
            okay1 = 0;
            okay2 = 0;
            okay3 = 0;
            okay4 = 0;
            okay1a = 1;
            okay2a = 1;
            okay3a = 1;
            okay4a = 1;

            if target1a==green
                okay1 = 1;
            end
            if target2a==green
                okay2 = 1;
            end
            if target3a==green
                okay3 = 1;
            end
            if target4a==green
                okay4 = 1;
            end

            if already==1
                okay1a = 0;
            end
            if already==2
                okay2a = 0;
            end
            if already==3
                okay3a = 0;
            end
            if already==4
                okay4a = 0;
            end

                if okay1 && okay1a
                    NEWinitball = posmat1a(:,ca(1,length(ba)),1);
                elseif okay2 && okay2a
                    NEWinitball = posmat2a(:,ca(1,p),1);
                elseif okay3 && okay3a
                    NEWinitball = posmat3a(:,ca(1,k),1);
                elseif okay4 && okay4a
                    NEWinitball = posmat4a(:,ca(1,u),1)
                end

                NEWinitballx = (NEWinitball(1)+center(1))-11;
                NEWinitbally = (NEWinitball(2)+center(2))-11;

                Screen('DrawLine', w, [255,255,255], (NEWinitballx-40), (NEWinitbally-40), (NEWinitballx), (NEWinitbally), 2);
                Screen('DrawLine', w, [255,255,255], (NEWinitballx), (NEWinitbally-14), (NEWinitballx), (NEWinitbally), 2);
                Screen('DrawLine', w, [255,255,255], (NEWinitballx-14), (NEWinitbally), (NEWinitballx), (NEWinitbally), 2);

                %As well as drawing the old arrow:
                Screen('DrawLine', w, [255,255,255], (initballx-40), (initbally-40), (initballx), (initbally), 2);
                Screen('DrawLine', w, [255,255,255], (initballx), (initbally-14), (initballx), (initbally), 2);
                Screen('DrawLine', w, [255,255,255], (initballx-14), (initbally), (initballx), (initbally), 2);

                %As well as drawing all the balls and the instruc2:
                DrawFormattedText(w, instruc2, 'center', 50, [255,255,255]);
                Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
                Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

                Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 44, target1a, center, 1);
                Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 44, distractor1a, center, 1);

                Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 5, target2a, center, 1);
                Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 25, distractor2a, center, 1);

                Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 30, target3a, center, 1);
                Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3a, center, 1);

                Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 1, target4a, center, 1);
                Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4a, center, 1);

                Screen('DrawingFinished', w);
                Screen('Flip', w);
                WaitSecs(0.3);

                KbWait;

 % ---------------------- instruc 3 ---------------------- %

    DrawFormattedText(w, instruc3, 'center', 50, [255,255,255]);
    Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
    Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);

    Screen('DrawDots', w, posmat1a(:,ca(1,i),1), 15, target1a, center, 1);
    Screen('DrawDots', w, posmat1b(:,ca(1,i),1), 15, distractor1a, center, 1);

    Screen('DrawDots', w, posmat2a(:,ca(1,p),1), 15, target2a, center, 1);
    Screen('DrawDots', w, posmat2b(:,ca(1,p),1), 15, distractor2a, center, 1);

    Screen('DrawDots', w, posmat3a(:,ca(1,k),1), 15, target3a, center, 1);
    Screen('DrawDots', w, posmat3b(:,ca(1,k),1), 15, distractor3a, center, 1);

    Screen('DrawDots', w, posmat4a(:,ca(1,u),1), 15, target4a, center, 1);
    Screen('DrawDots', w, posmat4b(:,ca(1,u),1), 15, distractor4a, center, 1);

    Screen('DrawingFinished', w);
    Screen('Flip', w);
    WaitSecs(0.3);
    KbWait;

    % ------------------ Draw moving demo circles --------------------- %

    z=0;
    while z <= 248
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
%         msg = s.GetScaledData;
%         xcoords = cat(1,xcoords,msg(4,1));
%
        z=z+1;
        i = i+1;
        p = p+1;
        k = k+1;
        u = u+1;
    end;

 % --------------------------- instruc 4: --------------------------- %
    % Hightlight probe:

        DrawFormattedText(w, instruc4, 'center', 50, [255,255,255]);
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

        Screen('DrawingFinished', w);
        vbl=Screen('Flip', w);
%         msg = s.GetScaledData;
%         xcoords = cat(1,xcoords,msg(4,1));

        WaitSecs(1.5)

else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                                   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  DEMO FINISHED, now test trials:  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                                   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ===================presentation=============================

     for i = 1:30
     Screen('Drawline',w, 150, width/2-6, height/2, width/2+6, height/2,2);
      Screen('Drawline',w, 150, width/2, height/2-6, width/2, height/2+6,2);
       Screen('Flip', w);
     end;


      starT=GetSecs;
 %===================firsttime=============================

z=0;
    while z <= 2*Hz;
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

        Screen('DrawingFinished', w);
        vbl=Screen('Flip', w);
%         msg = s.GetScaledData;
%         xcoords = cat(1,xcoords,msg(4,1));

        z=z+1;
    end;

   % =====================secondtime  ===============================

z=0;
    while z <= 248
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
%         msg = s.GetScaledData;
%         xcoords = cat(1,xcoords,msg(4,1));

        z=z+1;
        i = i+1;
        p = p+1;
        k = k+1;
        u = u+1;
    end;

   % ========================thirdtime===================
 z = 0;
    while z <= 90

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

        Screen('DrawingFinished', w);
        vbl=Screen('Flip', w);
%         msg = s.GetScaledData;
%         xcoords = cat(1,xcoords,msg(4,1));

        z=z+1;
    end



% final flip:
Screen('Flip',w);

end

        %% Get Response
        done = 0;
        noW = 0;

        while(~done)
            [eKey secs kCod] = KbCheck;
            if kCod(codD(1)) || kCod(codD(2)) ~= 0
                done = 1;
                noW = secs;
                cond(n,6) = find(kCod ~= 0);
                cond(n,7) = noW - starT;
            end
        end


          %% Check correct response
        if (cond(n,3) == -1) && (cond(n,6) == 58)
            cond(n,8) = 1; % correct (left)
        elseif (cond(n,3) == 1) && (cond(n,6) == 30)
            cond(n,8) = 1; % correct (right)
        else
            cond(n,8) = 0;
            end

        %cond(n,5)= str2double(sub_id);
% xcoordmax = max(cell2mat(xcoords));
% xcoordmin = min(cell2mat(xcoords));

% cond(n,9) = xcoordmin;
% cond(n,10) = xcoordmax;
% if cond(n,9) < 129.5 - 12.95
%     cond(n,11) = 0;
% elseif cond(n,10) > 129.5 +12.95
%     cond(n,11) = 0;
% else cond(n,11) = 1;
% end;

  WaitSecs(1);

end
% Close the connection
% s.Disconnect
%
% % Release the memory
% s.delete

 Priority(0);
    ShowCursor
    Screen('CloseAll');

    cond = cond(1:trialnumber,:);
    acc = mean(cond(1:demolength,8))
    acclast5 = mean(cond(demolength-4:demolength,8))
%% ===================== Draw Graph etc ===========================
% pos1 = find(cond(:,4) == 1);
% pos2 = find(cond(:,4) == 2);
% pos3 = find(cond(:,4) == 3);
% pos4 = find(cond(:,4) == 4);
% pos5 = find(cond(:,4) == 5);
% pos6 = find(cond(:,4) == 6);
% pos7 = find(cond(:,4) == 7);
% pos8 = find(cond(:,4) == 8);
% pos9 = find(cond(:,4) == 9);
% pos10 = find(cond(:,4) == 10);
% pos11 = find(cond(:,4) == 11);
% pos12 = find(cond(:,4) == 12);
% pos13 = find(cond(:,4) == 13);
% pos14 = find(cond(:,4) == 14);
% pos15 = find(cond(:,4) == 15);
% pos16 = find(cond(:,4) == 16);
%
% pos_same=find(cond(:,4)== 3 | cond(:,4) == 5 | cond(:,4) == 8 |...
%              cond(:,4) ==10 |cond(:,4) == 13 |cond(:,4) == 14 | ...
%              cond(:,4) ==15 |cond(:,4) == 16 );
% pos_opp=find(cond(:,4) == 1 | cond(:,4) == 2 | cond(:,4) == 4|...
%              cond(:,4) == 6 |cond(:,4) == 7 |cond(:,4) == 9 | ...
%              cond(:,4) ==11 |cond(:,4) == 12 );
%
% pos_same = cond(pos_same, :);
% pos_opp = cond(pos_opp, :);
%
% acc_same = length(find(pos_same(:,8) == 1))/length(pos_same(:,8));
% acc_opp = length(find(pos_opp(:,8) == 1))/length(pos_opp(:,8));
%
% % sLevel1 = cond(sameN1,:);
% % sLevel2 = cond(sameN2,:);
% %
% % sLevel1cream = cond(sLevel1(:,11) == 1);
% % sLevel2cream = sLevel2(:,11) == 1;
%
% %conglomerationofsamehemifields = average
% %conglomerationofoppohemifields =
% % Accuracy in each speed
% %As1 = length(find(pos1(:,8) == 1))/length(pos1(:,8));
% %As1 = length(find(pos1(:,8) == 1))/length(pos1(:,8));
%
%
% % Mean Reaction Time in each speed
% % Rs1 = mean(sLevel1(:,7))*1000;
% % Rs2 = mean(sLevel2(:,7))*1000;
%
%
% convertingspeedmattodegpersec = (speedmat./pixelsperdegree).*Hz;
%
% figure;
% subplot(1,2,1)
% plot([1 2],[acc_same acc_opp],'ro');
% hold on
% grid on
% axis([0.5 2.5 0 1.09]);
% set(gca,'XTickLabel',{' ', 's', ' ', 'd', ' '})
%
% title('Accuracy ');
% xlabel('condition');
% ylabel('Accuracy(%)');
%
%
% subplot(1,2,2)
% plot([convertingspeedmattodegpersec(1,1)...
%     convertingspeedmattodegpersec(1,length(speedmat))],[Rs1 Rs2],'bo-');
% hold on
% grid on
% title('Reaction Time');
% xlabel('speed (deg per sec)');
% ylabel('Reaction Time(ms)');
%
% %% ================= Write Data =====================
% num2str(sub_id);
% % backup save as a mat file
% save([sub_id '.mat'],'cond')
%
%
% fid = fopen([sub_id '_' num2str(now) '_DDbaseline.txt'],'w');
%
% fprintf(fid,'CenterSurroundGratingGrating\r\n');
% fprintf(fid,'\r\n');
% fprintf(fid,'%s\r\n',['subject ID: ' sub_id]);
% fprintf(fid,'\r\n');
%
%
% fprintf(fid,'----------------------------------------\r\n');
% fprintf(fid,'%s\r\n',['Accuracy  Same' num2str(speedmat(1,1)) ':  ' num2str(As1) ' %   ' sub_id]);
% %fprintf(fid,'%s\r\n',['Accuracy  Same' num2str(speedmat(1,2)) ':  ' num2str(As2) ' %   ' sub_id]);
% % fprintf(fid,'%s\r\n',['Accuracy  Same' num2str(speedmat(1,3)) ':  ' num2str(As3) ' %   ' sub_id]);
% % fprintf(fid,'%s\r\n',['Accuracy  Same' num2str(speedmat(1,4)) ':  ' num2str(As4) ' %   ' sub_id]);
% % fprintf(fid,'%s\r\n',['Accuracy  Same' num2str(speedmat(1,5)) ':  ' num2str(As5) ' %   ' sub_id]);
% fprintf(fid,'\r\n');
% fprintf(fid,'\r\n');
% fprintf(fid,'%s\r\n',['RT        Same' num2str(speedmat(1,1)) ':  ' num2str(Rs1) ' ms  ' sub_id]);
% %fprintf(fid,'%s\r\n',['RT        Same' num2str(speedmat(1,2)) ':  ' num2str(Rs2) ' ms  ' sub_id]);
% % fprintf(fid,'%s\r\n',['RT        Same' num2str(speedmat(1,3)) ':  ' num2str(Rs3) ' ms  ' sub_id]);
% % fprintf(fid,'%s\r\n',['RT        Same' num2str(speedmat(1,4)) ':  ' num2str(Rs4) ' ms  ' sub_id]);
% % fprintf(fid,'%s\r\n',['RT        Same' num2str(speedmat(1,5)) ':  ' num2str(Rs5) ' ms  ' sub_id]);
% fprintf(fid,'\r\n');
%
% fprintf(fid,'----------------------------------------\r\n');
% fprintf(fid,'\r\n');
% fprintf(fid,'----------------------------------------\r\n');
% fprintf(fid,'Trial CoherenceLevel Cdirection Sdirection Rep# ResponseKey RT Correct Congruent Sub_ID\r\n');
%
%      for i = 1:trialnumber
%          fprintf(fid,'%i\t %i\t %i\t %i\t %i\t %i\t %i\t %i\t %i\t %i\t %i\t %5.2f\t %i\t\r\n',...
%              cond(i,1),cond(i,2),cond(i,3),cond(i,4),...
%              cond(i,5),cond(i,6),cond(i,7),cond(i,8),...
%              cond(i,9),cond(i,10),cond(i,11));
%      end
%
% fprintf(fid,'----------------------------------------\r\n');
% fprintf(fid,'Column 1: Trial Number\r\n');
% fprintf(fid,'Column 2: Speed MS\r\n');
% fprintf(fid,'Column 3: target = probe? \r\n');
% fprintf(fid,'Column 4: Repetition number (meaningless)\r\n');
% fprintf(fid,'Column 5: Subject ID');
 Priority(0);
    ShowCursor
    Screen('CloseAll');
sub_id = num2str(sub_id);


%% ================= Write Data =====================

path = '/home/clinical_perception_lab/Desktop/research/mgh/colbosbattery/data/';
subid_str = num2str(sub_id);
clock=clock;
timer = strcat(num2str(clock(1)),'_',num2str(clock(2)),'_',num2str(clock(3)),'_',num2str(clock(4)),'_',num2str(clock(5)));

%saveas(gcf, [path 'Performance\' subid_str '_MOT_graph_' timer '.fig']) % save figure
filename =[path subid_str '_MOT_cond_' timer];
xlswrite([filename '.xls'], cond); % write cond to excel file

save([filename '.mat']);


% fprintf(fid,'Column 6: Subject Response. 89=yes,78=no\r\n');

% fprintf(fid,'Column 7: Reaction Time (ms)\r\n');
% fprintf(fid,'Column 8: Correct or not. 1=correct, 0=incorrect\r\n');
% fprintf(fid,'Column 9: minimum x gaze coordinate\r\n');
% fprintf(fid,'Column 10: maximum x gaze coordinate\r\n');
% fprintf(fid,'Column 11: throw out the ruddy trial?\r\n');
% fclose(fid);
