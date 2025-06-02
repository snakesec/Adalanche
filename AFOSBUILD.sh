rm -rf /opt/ANDRAX/adalanche
rm -rf /opt/ANDRAX/bin/adalanche

mkdir /opt/ANDRAX/adalanche

mkdir adalanche-bins

COMMIT=$(git rev-parse --short HEAD)
VERSION="v2025.06.02-ANDRAX-NG"

go build -ldflags "-X github.com/lkarlslund/adalanche/modules/version.Commit=$COMMIT -X github.com/lkarlslund/adalanche/modules/version.Version=$VERSION" -o adalanche-bins/adalanche adalanche/main.go

if [ $? -eq 0 ]
then
  # Result is OK! Just continue...
  echo "Go build ADALANCHE... PASS!"
else
  # houston we have a problem
  exit 1
fi

strip adalanche-bins/adalanche

GOOS=windows GOARCH=amd64 go build -o adalanche-bins/collector.exe -tags collector ./adalanche/

if [ $? -eq 0 ]
then
  # Result is OK! Just continue...
  echo "Go build COLLECTOR... PASS!"
else
  # houston we have a problem
  exit 1
fi

cp -Rf adalanche-bins/* /opt/ANDRAX/adalanche

if [ $? -eq 0 ]
then
  # Result is OK! Just continue...
  echo "Copy bins... PASS!"
else
  # houston we have a problem
  exit 1
fi

cp -Rf adalanche-sampledata /opt/ANDRAX/adalanche

if [ $? -eq 0 ]
then
  # Result is OK! Just continue...
  echo "Copy sample data... PASS!"
else
  # houston we have a problem
  exit 1
fi

ln -s /opt/ANDRAX/adalanche/adalanche /opt/ANDRAX/bin/adalanche
