package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"gopkg.in/yaml.v3"
)

type ifconfig struct {
	Ip string `json:"ip"`
}

type request struct {
	Owasp_csrftoken string `yaml:"OWASP_CSRFTOKEN" json:"OWASP_CSRFTOKEN"`
	Orderid         string `yaml:"orderid" json:"orderid"`
	Zoneid          string `yaml:"zoneid" json:"zoneid"`
	Domainname      string `yaml:"domainname" json:"domainname"`
	Type            string `yaml:"type" json:"type"`
	Rrid            string `yaml:"rrid" json:"rrid"`
	Name            string `yaml:"name" json:"name"`
	Clazz           string `yaml:"clazz" json:"clazz"`
	IPvalue         string `yaml:"IPvalue" json:"IPvalue"`
	Ttl             string `yaml:"ttl" json:"ttl"`
	Duration        string `yaml:"duration" json:"duration"`
	Submitform      string `yaml:"submitform" json:"submitform"`
}

type config struct {
	Request    request `yaml:"request"`
	Modify_url string  `yaml:"modify_url"`
	Login_url  string  `yaml:"login_url"`
}

func main() {
	// Get current external ip
	resp, err := http.Get("https://ifconfig.co/json")
	if err != nil {
		log.Fatalln(err)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	var ifconfig ifconfig
	err = json.Unmarshal(body, &ifconfig)
	if err != nil {
		log.Fatalln(err)
	}

	current_ip, err := os.ReadFile(".ip")
	if err != nil {
		log.Fatalln("Error loading .ip file")
	}

	if ifconfig.Ip != string(current_ip) {
		fmt.Println("UPDATE A RECORD")
		updateDns()

	}

}

func updateDns() {
	var conf config
	conf.getConf()
	data, err := json.Marshal(conf.Request)
	fmt.Println(string(data))
	req, err := http.NewRequest("POST", conf.Modify_url, bytes.NewBuffer(data))
	//req.Header.Set("X-Custom-Header", "myvalue")
	req.Header.Set("Content-Type", "application/json")
	req.AddCookie(&http.Cookie{
		Name:     "JSESSIONID",
		Value:    "D25CDE506645EB6929A82AE72970395D",
		Domain:   "14106635.dns.bll.myorderbox.com",
		Secure:   true,
		SameSite: http.SameSiteNoneMode,
		Path:     "/dnsbox",
		HttpOnly: true,
	})

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("response Status:", resp.Status)
	fmt.Println("response Headers:", resp.Header)
	body, _ := io.ReadAll(resp.Body)
	fmt.Println("response Body:", string(body))
}

func (c *config) getConf() *config {

	yamlFile, err := os.ReadFile("config.yaml")
	if err != nil {
		log.Printf("yamlFile.Get err   #%v ", err)
	}
	err = yaml.Unmarshal(yamlFile, c)
	if err != nil {
		log.Fatalf("Unmarshal: %v", err)
	}

	return c
}
