unit mGrade;

interface

uses
  Classes, SysUtils, ComCtrls;

type
  TmGrade = class(TListView)
  private
    fCollection : TCollection;
  public
  published
    property Collection : TCollection read fCollection write fCollection;
  end;

implementation

end.
