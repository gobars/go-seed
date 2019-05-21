# go-seed
**create golang template project with gin**

# install
`go get github.com/gobars/go-seed`

# create project
``` shell
cd /home/footstone
go-seed -path=study/tools
```

this shell will create a project like:

```
├── common
│   ├── const.go
│   ├── copier.go
│   ├── http.go
│   ├── json.go
│   ├── json_test.go
│   ├── log.go
│   ├── page.go
│   ├── page_test.go
│   ├── result.go
│   └── utils.go
├── control.sh //package stop start restart ...
├── controller
│   └── helloworld.go
├── etc
│   └── config.yaml
├── go.mod
├── go.sum
├── init.go
├── main.go
├── model
│   ├── db.go
│   └── helloworld.go
└── router.go
```

`go-seed -clean ` clean tmp dir .go-seed