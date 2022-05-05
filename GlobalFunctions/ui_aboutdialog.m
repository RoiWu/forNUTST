function ui_aboutdialog(appname,vernum,myicon)
size_myicon = [150,150];
figname = ['About ',appname];

ss = get(0,'screensize'); %The screen size
screen_w = ss(3);
screen_h = ss(4);
fig_w = 440;
fig_h = size_myicon(2);

fig_main = figure('Menubar','None','Name',figname, ...
  'NumberTitle','Off','DockControls','off','Resize','off', ...
  'Visible','on','Position',[(screen_w/2)-fig_w/2,(screen_h/2)-fig_h/2,fig_w,fig_h]);
fig_main.WindowStyle = 'modal';

hicon = axes('Units','pixels','Position',[0,0,size_myicon(1),size_myicon(2)]);
imshow(myicon,'parent',hicon);

message_text = appname;
uicontrol('Parent',fig_main,'Style','text','String',message_text,...
  'FontSize',12,'FontWeight','bold',...
  'HorizontalAlignment','left','Position',[size_myicon(2)+10,fig_h-60,300,30]);

% handles.vernum
message_text = [vernum,' (64-bit)'];
uicontrol('Parent',fig_main,'Style','text','String',message_text,...
  'FontSize',10,...
  'HorizontalAlignment','left','Position',[size_myicon(2)+10,fig_h-90,300,30]);

message_text = 'Electro-Optical Systems Laboratory - NTUST ';
uicontrol('Parent',fig_main,'Style','text','String',message_text,...
  'FontSize',10,...
  'HorizontalAlignment','left','Position',[size_myicon(2)+10,fig_h-135,300,30]);


message_text = 'Technical Support : ';
uicontrol('Parent',fig_main,'Style','text','String',message_text,...
  'FontSize',10,...
  'HorizontalAlignment','left','Position',[size_myicon(2)+10,fig_h-145,300,20]);

labelStr = '<html><center><a href="">fredericklie@gmail.com';
email_Callback = 'web(''mailto:fredericklie@gmail.com'');';
hButton = uicontrol('string',labelStr,'HorizontalAlignment','left',...
  'FontSize',10,'Position',[size_myicon(2)+125,fig_h-146,150,30],'Callback',email_Callback);
jButton = findjobj(hButton); % get FindJObj from the File Exchange
jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setContentAreaFilled(0); % or: jButton.setBorder([]);
end
