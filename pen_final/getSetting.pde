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
    String time = "";
    String note = "";
    
    XML xml = loadXML(url);
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
