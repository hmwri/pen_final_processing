class Driver {
  //ここにセンサーデータが入っている(単位cm　整数)
  //右 data.right 左 data.left 前 data.front 上 data.top
  int n =50;
  ArduinoData data;
  Driver(ArduinoData _data) {
    data = _data;
  }
  //センサーデータから次に行くべき方向を判断する。この関数は1フレームごとに呼ばれます。返した方向に向けてモーターが回転します。
  //返り値
  //前 Direction.Front 右 Direction.Right 左 Direction.Left 後ろ Direction.Back 停止 Direction.Stop
  Direction getNextDirection() {
    //八方塞がりなら停止
    if (data.front<n && data.back<n && data.right<n && data.left<n)
      return Direction.Stop;
    //前が行けないとき
    if (data.front<n) {
      if (data.back<n) {
        if (data.right<data.left) return Direction.Left;
        else return Direction.Right;
      }
      return Direction.Back;
    }
    //前以外が近いとき
    if (data.back<n || data.right<n || data.left<n) return Direction.Front;
    return Direction.Stop;
  }
}
