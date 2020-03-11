program testLiveBinding;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  NUser in '..\Common\NUser.pas',
  UDmViewModel in '..\Common\UDmViewModel.pas' {DmViewModel: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDmViewModel, DmViewModel);
  Application.Run;
end.
