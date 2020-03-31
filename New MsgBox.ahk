#SingleInstance,Force
global IE,wb

MyMsgbox:=New MsgBox()
MyMsgbox.SetText("Nice")
MyMsgbox.Show("Bland MsgBox")
/*
	This is all that is required for a Standard MsgBox
*/
MyMsgbox:=New MsgBox({ThemeColor:"Red",Background:"#000000",Color:"#AAAAAA",Gradient:1,Icon:"https://cdn.pixabay.com/photo/2012/04/01/19/21/exclamation-mark-24144_960_720.png"})
/*
	ThemeColor, Background, or Color: can be any Standard HTML color or a #RRGGBB Code
	Gradient: Anything other than 0 will cause it to create a Background Gradient on the Icon, Text, and Buttons
	Icon: Can be anything you like but X, !, I, or ? will have a UTF-8 replacement
*/
MyMsgbox.SetCSS({Button:{Size:50}}) ;Change the Font-Size of all of the Buttons
MyMsgbox.SetButtonCSS({OK:{Color:"Pink",Background:{0:"Black",50:"Red",100:"Black"}},Studio:{Color:"Purple",Background:"Pink"},ExitApp:{Color:"Orange"},Clipboard:{Color:"Red"}})
/*
	SetCSS can also work with the Buttons individually
*/
HTML:=01
Rows:=2
Columns:=2
RandomWords(HTML)
MyMsgbox.Show("Click OK For Crazy")
MyMsgbox:=New MsgBox({Gradient:1,Icon:"X"})
Display:=1
MyMsgbox.SetButtons("&Nice,Can &Be Anything,Y&AY!")
if(Display=1){
	RandomWords(HTML)
}else if(Display=2){
	MyMsgbox.SetText({Farts:{Butts:"Coconuts"},More:{Butts:"Coconuts"},Even:[1,2,4]})
}else if(Display=3){
	MyMsgbox.SetText("<Img SRC='https://lh6.googleusercontent.com/-P_mKjzFRtIA/AAAAAAAAAAI/AAAAAAAABgk/gwOqVS-DCz4/photo.jpg?sz=48'/>")
}
SetTimer,RandomMsg,500
Result:=MyMsgbox.Show("Normal MsgBox",1)
SetTimer,RandomMsg,Off
m("You pressed: " Result)
;~ Result:=MyMsgbox.Show("asdfffff",1)
ExitApp
return
RandomMsg(){
	global
	static Count:=1
	if(!WinExist(MyMsgbox.ID)&&!MyMsgbox.Testing)
		ExitApp
	MyMsgbox.Testing:=1
	static Start:=["Left","Top","Right","Bottom"],Icon:=["!","X","?","I"]
	RandomWords(1)
	MyMsgbox.SetBackground({Start:Start[Mod(++Count,4)+1],0:MyMsgbox.ThemeColor,100:"#000"},"Text")
	Colors:=[]
	for a,b in StrSplit("Nice,Can Be Anything,YAY!,Clipboard,ExitApp,Studio",","){
		Colors[b]:=[]
		for c,d in ["Background","Color"]{
			Random,Color,0x000000,0xFFFFFF
			CC:="#" Format("{:x}",Color)
			if(d="Color")
				Colors[b,d]:=CC
			if(d="Background")
				Colors[b,d]:={Start:Start[Mod(++Count,4)+1],0:"#000",100:CC}
		}
	}
	MyMsgbox.SetButtonCSS(Colors)
	MyMsgbox.SetIcon(Icon[Mod(Count,4)+1])
}
RandomWords(HTML){
	global MyMsgbox,Rows,Columns
	Loop,%Rows%
	{
		Loop,%Columns%{
			Random,Random,10,40
			Random,Color,0x000000,0xFFFFFF
			Text.=HTML?"<Font Style='Font-Size:" Random "px;Color:#" Format("{:x}",Color) "'>Words </Font>":"Words "
		}
		Text.="`n"
	}
	(HTML)?MyMsgbox.SetHTML(Text):MyMsgbox.SetText(Text)
}
t(x*){
	for a,b in x{
		if(!IsObject(b))
			Text:=b
		if(!Text)
			Try
				Text:=b.OuterHTML
		if(!Text)
			Try
				Text:=b.XML
		if(!Text)
			Text:=Obj2String(b)
		Msg.=(Text?Text:b) "`n"
	}
	ToolTip,%Msg%
}
m(x*){
	for a,b in x
		Msg.=(IsObject(b)?Obj2String(b):b) "`n"
	MsgBox,%Msg%
}
Obj2String(Obj,FullPath:=1,BottomBlank:=0){
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b)&&b.OuterHtml)
				String.=FullPath "." a " = " b.OuterHtml
			else if(IsObject(b)&&!b.XML)
				Obj2String(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
				else if(b!="")
					String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}