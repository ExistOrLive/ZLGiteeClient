#!/usr/bin/python
# -*- coding: UTF-8 -*-
import requests
import sys

def main():

   token = sys.argv[1]

   result = requests.get("https://api.github.com/repos/ExistOrLive/SecretFile/contents/GiteeClient/ZLGiteeAppKey.h",
                          headers={"Authorization":"token "+token,"Accept":"application/vnd.github.v3.raw+json"})
   if result.status_code == 200 :
       open("ZLGiteeAppKey.h",'wb').write(result.content)
       print("ZLGiteeAppKey.h download success")
   else :
       print(result)

if __name__ == '__main__':
    main()

