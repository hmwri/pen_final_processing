package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"net/http"
	"os/exec"
	"regexp"
	"strings"

	"golang.org/x/net/http2"
)

func main() {
	server := http.Server{}
	http2.ConfigureServer(&server, &http2.Server{})
	http.HandleFunc("/post", post)
	http.HandleFunc("/setting", getSetting)
	http.HandleFunc("/getInfo", getInfo)
	http.ListenAndServeTLS(":8081", "/etc/letsencrypt/live/hmwri.com/cert.pem", "/etc/letsencrypt/live/hmwri.com/privkey.pem", nil)
}

var time = "0000"
var link = "default"

type XML struct {
	Time string `xml:"time"`
	Note string `xml:"note"`
}

func post(w http.ResponseWriter, request *http.Request) {
	//POSTを取得
	request.ParseForm()
	if len(request.Form) == 0 {
		fmt.Println("Empty Request")
		return
	}
	if request.Method != "POST" {
		return
	}
	println(request.Method)
	//リクエストからプログラムを取得し保存
	_time := strings.Join(request.Form["time"][:], "")
	var correctNumber = regexp.MustCompile(`^[0-9]{4}$`)
	w.Header().Set("Content-Type", "text/plain")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	if !correctNumber.MatchString(_time) {
		fmt.Println("No match")
		w.Write([]byte("ERROR No MAtch"))
		return
	}
	time = _time
	music_link := strings.Join(request.Form["music"][:], "")

	fmt.Println("time:" + time + "music:" + music_link)
	ls, err := exec.Command("/usr/bin/python3", "/root/go/src/pen_final/fft.py", music_link).Output()
	if err != nil {
		fmt.Printf("hello ls:\n%s :Error:\n%v\n", ls, err)
		w.Write([]byte("FFT ERROR"))
		return

	}
	data, _ := ioutil.ReadFile("note.txt")
	note := string(data)
	v := &XML{Time: time, Note: note}
	output, err := xml.MarshalIndent(v, "  ", "    ")

	if err != nil {
		fmt.Println(err)
	}

	setting_data := []byte(output)
	err = ioutil.WriteFile("/var/www/html/pen_final/setting.xml", setting_data, 0777)
	if err != nil {
		fmt.Println(err)
	}
	link = music_link

	w.Write([]byte("OK"))
	//ファイルを閉じる
}

func getSetting(w http.ResponseWriter, request *http.Request) {
	w.Header().Set("Content-Type", "application/xml")
	data, _ := ioutil.ReadFile("note.txt")
	note := string(data)
	fmt.Println(note)
	v := &XML{Time: time, Note: note}
	output, err := xml.MarshalIndent(v, "  ", "    ")

	if err != nil {
		fmt.Println(err)
	}

	w.Write(output)
}

func getInfo(w http.ResponseWriter, request *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	r := time + "," + link
	w.Write([]byte(r))
}
