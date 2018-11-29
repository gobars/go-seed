package main

import (
	"github.com/gobuffalo/packr"
	"flag"
	"os"
	"path"
	"strings"
	"fmt"
	"text/template"
	"bytes"
	"io/ioutil"
)

type Context struct {
	Path string
}

var ctx = Context{}
var p = flag.String("path", "go-seed", "project path")
var clean = flag.Bool("clean", false, "clean")

var box = packr.NewBox("./resources")
var tempDir = ".go-seed"

const templateFile = ".template"

func main() {
	flag.Parse()
	dir, _ := os.Getwd()
	if *clean {
		cleanProject(path.Join(dir, tempDir))
		os.Exit(0)
		return
	}
	ctx.Path = *p

	targetDir := path.Join(dir, tempDir, *p)
	fmt.Println("will create project in " + targetDir)
	if err := os.MkdirAll(targetDir, os.ModePerm); err != nil {
		panic("create dir error " + err.Error())
	}
	files := box.List();
	for _, f := range files {
		if strings.HasPrefix(f, ".") {
			continue
		}
		target := path.Join(targetDir, f)
		createFile(target, f)
	}

	if err := os.Rename(path.Join(dir, tempDir, root(*p)), path.Join(dir, root(*p))); err != nil {
		cleanProject(path.Join(dir, tempDir))
		fmt.Println("fail to create project " + *p + " with err " + err.Error())
		os.Exit(0)
		return
	}
	cleanProject(path.Join(dir, tempDir))
	fmt.Println("success create project " + *p)

}
func root(s string) string {
	return strings.Split(s, "/")[0]
}

func cleanProject(targe string) bool {
	err := os.RemoveAll(targe)
	if err != nil {
		fmt.Println("clean err with " + err.Error())
		return false
	}
	return true
}

func createFile(target string, inner string) {
	dir := path.Dir(target)
	fileNameSplit := strings.Split(inner, "/")
	fileName := fileNameSplit[len(fileNameSplit)-1]
	if err := os.MkdirAll(dir, os.ModePerm); err == nil {
		if strings.HasSuffix(fileName, templateFile) {
			fileName = fileName[:len(fileName)-len(templateFile)]
		}
		realFile := path.Join(dir, fileName)
		t := template.New("seed template")
		templateStr := box.String(inner)
		t, _ = t.Parse(templateStr)
		var buff bytes.Buffer
		if err := t.Execute(&buff, ctx); err != nil {
			panic(err)
		}
		fmt.Println("create file " + realFile)
		if err := ioutil.WriteFile(realFile, buff.Bytes(), os.ModePerm); err != nil {
			panic(err)
		}

	}
}
