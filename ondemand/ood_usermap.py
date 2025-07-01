#!/usr/bin/env python3

import ldap
import sys
import re
import urllib.parse

decoded = urllib.parse.unquote(sys.argv[1])
try:
  l = ldap.initialize('ldap://ldap1.orca.pdx.edu')
except ldap.LDAPError as e:
  sys.exit(1)

try:
  results = l.search_s('ou=users,o=orca', ldap.SCOPE_SUBTREE, f'(eduPersonPrincipalName={decoded})', ['uid'])
except ldap.LDAPError as e:
  sys.exit(1)

if len(results) > 0:
    uid = results[0][1]['uid'][0].decode()
    print(uid)
    sys.exit(0)


sys.exit(1)
