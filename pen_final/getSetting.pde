class WebAPI {
  String url ;
  SettingData preData;
  WebAPI(String _url){
    url = _url;
  }
  
  /// webAPIから設定値を取得し、変数time、変数noteにそれぞれ代入してください
  /// XMLファイルはこちらを参照 https://hmwri.com:8081/setting
  /// この関数の役割:
  /// urlからXMLを取得し、timeとnoteを取り出す。取得した文字列からSettingDataを生成し返す。
  /// なお、この関数は一定間隔で呼び出され、前回取得した内容と違いがなかった場合はnull,違いがあった場合はSettingDataを返す
  SettingData getData() {
    String time = "1218";
    String note = "000R08CI0C8L0A0409G808C7078L08CA09GA0B4909G20A0408W6078P000D07S208CI0C8L0A0508W608C9078K08CA09GB0B490A0508W708CP000E08CI0C8L0A0409G808C7078L08CA09GA0B4909G20A0408W6078P000F08CI0C8L0A0508W608C8078L08CA09G4";
    
    XML xml = loadXML("https://hmwri.com:8081/setting");
    time = xml.getChild("time").getContent();
    note = xml.getChild("note").getContent();
    
    if(preData != null && preData.time.equals(time) && preData.note.equals(note)){
      return null;
    }
    preData = new SettingData(time, note);
    return preData;
  }
}

//設定データ管理用クラス
class SettingData{
  String time;
  String note;
  SettingData(String _time, String _note) {
    time = _time;
    note = _note;
  }
}
