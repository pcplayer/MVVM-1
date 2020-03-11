program testLiveBindingFmx;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  NUser in '..\Common\NUser.pas',
  UDmViewModel in '..\Common\UDmViewModel.pas' {DmViewModel: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDmViewModel, DmViewModel);
  Application.Run;
end.
