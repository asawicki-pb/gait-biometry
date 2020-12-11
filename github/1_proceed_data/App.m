% Manual range selector
% by Aleksander Sawicki 

day=1;
LIMS=cell(20,2);

LIMS{1,1}=  [1198,11331;
            11630,24304];

LIMS{2,1}=  [530,15420;
            15560,24120;
            24540,27650];

LIMS{3,1}=  [2576,5428;
            6928,19640;
            20760,29450];

LIMS{4,1}=  [1009,9464;
            10510,21400;
            21560,22750;
            22990,24980;
            25150,25460;
            25680,27170];   

LIMS{5,1}=  [504,19570;
            19840,27570]; 

LIMS{6,1}=  [1027,5555;
            5696,7550;
            9655,16370;
            16540,17750;
            18040,18610;
            18830,20430;
            20510,25230;
            25410,25770;
            26060,29300;
            29400,32180;
            32250,34340]; 

LIMS{7,1}=  [1,8062;
            8405,9558;
            9626,13980;
            14800,17830;
            20330,23530;
            24640,26170;
            26330,37170]; 

LIMS{8,1}=  [1,3970;
            4371,6869;
            7055,7965;
            8015,9361;
            9481,10359;
            10395,12281;
            12501,18049;
            19145,19908;
            19969,21858;
            22709,23639;
            25141,28222]; 

LIMS{9,1}=  [710,5354
            5431,15450
            15810,18580
            20890,28820]; 
        
LIMS{10,1}= [1157,7092
            7320,14470
            14670,15550
            16210,24270
            24380,26400
            26730,28430]; 

LIMS{11,1}= [1729,8730
            8815,14730
            14800,22170
            22530,24270
            24380,27280];

LIMS{12,1}= [972,8544
            9955,12560
            12879,15914
            18999,19860
            19874,20805
            24726,25618
            25622,26395
            26457,30310
            30370,34334];
   
LIMS{13,1}= [2486,26713];
 
LIMS{14,1}= [82,13408
            13434,16659
            16700,33860];
   
LIMS{15,1}= [439,17240
            17500,28430
            28539,29080];
        
LIMS{16,1}= [414,17560
            17610,32720];   
   
LIMS{17,1}= [511,5688
            5765,6568
            6650,7102
            7341,21830
            21870,22780
            23100,26490
            26720,27580
            27750,29370];
        
LIMS{18,1}= [1310,6534
            6680,7877
            8886,11160
            13280,14120
            15820,19120
            22460,33180];   
  
LIMS{19,1}= [825,16850
            17110,22960
            23220,26000
            26160,29960];  

LIMS{20,1}= [657,24826];
%----------------------------------------------------------
addpath('library/')  
%----------------------------------------------------------

for participant=[1:20]

    fprintf('../gait-dataset/w%03dday1-raw.csv\n',participant)

    Limits=LIMS{participant,1};
    %----------------------------------------------------------
    ranges=[]; %storage idx
    for r=1:size(Limits,1)
        ranges=[ranges,[Limits(r,1):Limits(r,2)]];
    end
    %----------------------------------------------------------
    % DATA EXTRACTION
    [day1,timestamp]=extractData(sprintf('../gait-dataset/w%03dday1-raw.csv',participant));
    day_original=day1;
    day1=day1(ranges,:);
    % DATA SAVING
    if ~exist('../gait-manual-separation/', 'dir')
       mkdir('../gait-manual-separation/')
    end
    output_pth = sprintf('../gait-manual-separation/w%03dday1-raw.csv',participant);
    writetable(day1,output_pth)    
    %----------------------------------------------------------   
    % VISUAL PRESENTATION 
    a=day_original.a;
    a_norm=zeros(size(a,1),1);
    for i=1:size(a,1)
        a_norm(i)=norm(a(i,:));
        fprintf('%d /%d\t%.2f',i,size(a,1),i/size(a,1)*100)
    end
    
    fig=figure(participant)
    plot(a_norm,'k')
    hmax=max(get(gca,'YLim'));
    hmin=min(get(gca,'YLim'));
    for r=1:size(Limits,1)
        rectangle('Position',[Limits(r,1), hmin, (Limits(r,2)-Limits(r,1)), (hmax-hmin)], 'FaceColor',[0.5 .0 .0 0.2])
    end 
    title(sprintf('Participant %d',participant))
    if ~exist('img/', 'dir')
       mkdir('img/')
    end
    saveas(fig,sprintf('img/participant_%d_day_1.png',participant))
end
