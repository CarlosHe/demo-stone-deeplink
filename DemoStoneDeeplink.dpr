program DemoStoneDeeplink;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'src\views\View.Main.pas' {MainView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
