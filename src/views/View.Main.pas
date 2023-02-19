unit View.Main;

interface

uses
  Stone.Deeplink,
  Stone.Deeplink.Component.Application,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Platform,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Objects,
  FMX.Layouts,
  FMX.Edit,
  FMX.ComboEdit,
  FMX.ListBox;

type
  TMainView = class(TForm)
    ButtonPayment: TButton;
    MemoOutput: TMemo;
    ButtonCancelation: TButton;
    EditPaymentAmount: TEdit;
    LayoutPayment: TLayout;
    TextAmount: TText;
    LayoutCancelation: TLayout;
    StoneDeeplink: TStoneDeeplink;
    EditCancelationATK: TEdit;
    TextCancelationATK: TText;
    EditCancelationAmount: TEdit;
    TextCancelationAmount: TText;
    LayoutPaymentAmount: TLayout;
    LayoutCancelationATK: TLayout;
    LayoutCancelationAmount: TLayout;
    LayoutPaymentTransactionType: TLayout;
    TextPaymentTransactionType: TText;
    ComboBoxPaymentTransactionType: TComboBox;
    LayoutPaymentInstallmentType: TLayout;
    TextPaymentInstallmentType: TText;
    ComboBoxPaymentInstallmentType: TComboBox;
    LayoutPaymentInstallmentCount: TLayout;
    TextPaymentInstallmentCount: TText;
    ComboBoxPaymentInstallmentCount: TComboBox;
    LayoutPaymentEditableAmount: TLayout;
    TextPaymentEditableAmount: TText;
    SwitchPaymentEditableAmount: TSwitch;
    procedure ButtonPaymentClick(Sender: TObject);
    procedure ButtonCancelationClick(Sender: TObject);
    procedure StoneDeeplinkPaymentSuccess(const Sender: TObject; const APaymentReturn: IStoneDeeplinkPaymentReturnEntity);
    procedure StoneDeeplinkPaymentError(const Sender: TObject; const ACode: Integer; const AMessage: string);
    procedure StoneDeeplinkCancelationError(const Sender: TObject; const AReason, AResponseCode: string);
    procedure StoneDeeplinkCancelationSuccess(const Sender: TObject; const ACancelationReturn: IStoneDeeplinkCancelationReturnEntity);
    procedure EditAmountTap(Sender: TObject; const Point: TPointF);
    procedure EditAmountTyping(Sender: TObject);
    procedure EditAmountClick(Sender: TObject);
    procedure EditCancelationATKChange(Sender: TObject);
    procedure EditCancelationATKTyping(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTransactionType;
    procedure LoadInstallmentType;
    procedure LoadInstallmentCount;
    procedure ResetAmount(const AEdit: TEdit);
    procedure FormatEditAmount(const AEdit: TEdit);
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

uses
  System.Math,
  System.TypInfo,
  Stone.Deeplink.Enum.InstallmentType,
  Stone.Deeplink.Enum.TransactionType,
  Stone.Deeplink.Enum.EditableAmountType,
  Stone.Deeplink.Helper.Enum.InstallmentType,
  Stone.Deeplink.Helper.Enum.TransactionType,
  Stone.Deeplink.Helper.AmountType,
  Stone.Deeplink.Types;

{$R *.fmx}


procedure TMainView.ButtonPaymentClick(Sender: TObject);
begin
  StoneDeeplink.CallPayment(
    TStoneDeeplinkPaymentEntityBuilder.New
    .SetInstallmentType(TStoneDeeplinkInstallmentType(ComboBoxPaymentInstallmentType.ItemIndex))
    .SetInstallmentCount(ComboBoxPaymentInstallmentCount.Selected.Text.ToInteger)
    .SetAmount(TStoneDeeplinkAmount.FromString(EditPaymentAmount.Text))
    .SetTransactionType(TStoneDeeplinkTransactionType(ComboBoxPaymentTransactionType.ItemIndex))
    .SetEditableAmount(TStoneDeeplinkEditableAmountType(SwitchPaymentEditableAmount.IsChecked.ToInteger))
    .Build
    );
end;

procedure TMainView.ButtonCancelationClick(Sender: TObject);
begin
  StoneDeeplink.CallCancelation(
    TStoneDeeplinkCancelationEntityBuilder.New
    .SetAmount(TStoneDeeplinkAmount.FromString(EditCancelationAmount.Text))
    .SetATK(EditCancelationATK.Text.ToInt64)
    .SetEditableAmount(TStoneDeeplinkEditableAmountType.Uneditable)
    .Build
    );
end;

procedure TMainView.EditAmountTap(Sender: TObject; const Point: TPointF);
begin
  EditAmountClick(Sender);
end;

procedure TMainView.EditAmountTyping(Sender: TObject);
begin
  FormatEditAmount(TEdit(Sender));
end;

procedure TMainView.EditCancelationATKChange(Sender: TObject);
begin
  ButtonCancelation.Enabled := not EditCancelationATK.Text.IsEmpty;
end;

procedure TMainView.EditCancelationATKTyping(Sender: TObject);
begin
  EditCancelationATKChange(Sender);
end;

procedure TMainView.FormatEditAmount(const AEdit: TEdit);
begin
  AEdit.Text := FormatCurr('##0.00', ('0' + AEdit.Text.Replace('.', EmptyStr).Replace(',', EmptyStr)).ToDouble / 100);
  AEdit.CaretPosition := AEdit.Text.Length;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  ResetAmount(EditPaymentAmount);
  ResetAmount(EditCancelationAmount);
  LoadTransactionType;
  LoadInstallmentType;
  LoadInstallmentCount;
end;

procedure TMainView.EditAmountClick(Sender: TObject);
begin
  ResetAmount(TEdit(Sender));
end;

procedure TMainView.LoadInstallmentCount;
var
  LStoneDeeplinkInstallmentCount: TStoneDeeplinkInstallmentCount;
begin
  ComboBoxPaymentInstallmentCount.Clear;
  for LStoneDeeplinkInstallmentCount := Low(TStoneDeeplinkInstallmentCount) to High(TStoneDeeplinkInstallmentCount) do
    ComboBoxPaymentInstallmentCount.Items.Add(Byte(LStoneDeeplinkInstallmentCount).ToString);
  ComboBoxPaymentInstallmentCount.ItemIndex := ComboBoxPaymentInstallmentCount.Items.IndexOf(Low(LStoneDeeplinkInstallmentCount).ToString);
end;

procedure TMainView.LoadInstallmentType;
var
  LStoneDeeplinkInstallmentType: TStoneDeeplinkInstallmentType;
begin
  ComboBoxPaymentInstallmentType.Clear;
  for LStoneDeeplinkInstallmentType := Low(TStoneDeeplinkInstallmentType) to High(TStoneDeeplinkInstallmentType) do
    ComboBoxPaymentInstallmentType.Items.Add(LStoneDeeplinkInstallmentType.ToString);
  ComboBoxPaymentInstallmentType.ItemIndex := ComboBoxPaymentInstallmentType.Items.IndexOf(TStoneDeeplinkInstallmentType.None.ToString);
end;

procedure TMainView.LoadTransactionType;
var
  LStoneDeeplinkTransactionType: TStoneDeeplinkTransactionType;
begin
  ComboBoxPaymentTransactionType.Clear;
  for LStoneDeeplinkTransactionType := Low(TStoneDeeplinkTransactionType) to High(TStoneDeeplinkTransactionType) do
    ComboBoxPaymentTransactionType.Items.Add(LStoneDeeplinkTransactionType.ToString);
  ComboBoxPaymentTransactionType.ItemIndex := ComboBoxPaymentTransactionType.Items.IndexOf(TStoneDeeplinkTransactionType.Debit.ToString);
end;

procedure TMainView.ResetAmount(const AEdit: TEdit);
begin
  AEdit.Text := FormatCurr('##0.00', 0);
  AEdit.CaretPosition := AEdit.Text.Length;
end;

procedure TMainView.StoneDeeplinkCancelationError(const Sender: TObject; const AReason, AResponseCode: string);
begin
  ShowMessage(Format('[reason: %s] [response_code: %s] Error when canceling', [AReason, AResponseCode]));
end;

procedure TMainView.StoneDeeplinkCancelationSuccess(const Sender: TObject; const ACancelationReturn: IStoneDeeplinkCancelationReturnEntity);
begin
  MemoOutput.Lines.Add('CANCELATION');
  MemoOutput.Lines.Add('ATK:                         ' + ACancelationReturn.GetATK.ToString);
  MemoOutput.Lines.Add('CANCELED AMOUNT:             ' + ACancelationReturn.GetCanceledAmount.ToFormatCurr);
  MemoOutput.Lines.Add('PAYMENT TYPE:                ' + ACancelationReturn.GetPaymentType.ToString);
  MemoOutput.Lines.Add('TRANSACTION AMOUNT:          ' + ACancelationReturn.GetTransactionAmount.ToFormatCurr);
  MemoOutput.Lines.Add('AUTHORIZATION CODE:          ' + ACancelationReturn.GetAuthorizationCode.ToString);
  MemoOutput.Lines.Add('REASON:                      ' + ACancelationReturn.GetReason);
  MemoOutput.Lines.Add('RESPONSE CODE:               ' + ACancelationReturn.GetResponseCode);
  MemoOutput.Lines.Add('------------------------------------------------------------');
end;

procedure TMainView.StoneDeeplinkPaymentError(const Sender: TObject; const ACode: Integer; const AMessage: string);
begin
  ShowMessage(Format('[code: %s] [message: %s] Error when making payment', [ACode.ToString, AMessage]));
end;

procedure TMainView.StoneDeeplinkPaymentSuccess(const Sender: TObject; const APaymentReturn: IStoneDeeplinkPaymentReturnEntity);
begin
  EditCancelationATK.Text := APaymentReturn.GetATK.ToString;
  EditCancelationAmount.Text := APaymentReturn.GetAmount.ToFormatCurr;

  MemoOutput.Lines.Add('PAYMENT');
  MemoOutput.Lines.Add('AMOUNT:                      ' + APaymentReturn.GetAmount.ToFormatCurr);
  MemoOutput.Lines.Add('CARDHOLDER NAME:             ' + APaymentReturn.GetCardholderName);
  MemoOutput.Lines.Add('ITK:                         ' + APaymentReturn.GetITK);
  MemoOutput.Lines.Add('ATK:                         ' + APaymentReturn.GetATK.ToString);
  MemoOutput.Lines.Add('AUTHORIZATION DATETIME:      ' + DateTimeToStr(APaymentReturn.GetAuthorizationDateTime));
  MemoOutput.Lines.Add('BRAND:                       ' + APaymentReturn.GetBrand);
  MemoOutput.Lines.Add('AUTHORIZATION CODE:          ' + APaymentReturn.GetAuthorizationCode.ToString);
  MemoOutput.Lines.Add('TYPE:                        ' + APaymentReturn.GetType.ToString);
  MemoOutput.Lines.Add('------------------------------------------------------------');
end;

end.
