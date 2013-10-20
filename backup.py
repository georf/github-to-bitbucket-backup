import urllib
import urllib2
import json
import base64
import commands

bitbucket = {}
execfile("bitbucket.conf", bitbucket) 

def find_or_create_bitbucket_repo(name):
  base64string = base64.encodestring('%s:%s' % (bitbucket["username"], bitbucket["password"])).replace('\n', '')

  request = urllib2.Request("https://bitbucket.org/api/1.0/user/repositories")
  request.add_header("Authorization", "Basic %s" % base64string)   
  response = urllib2.urlopen(request)
  repos = json.load(response)

  for repo in repos:
    if repo[u'name'] == name:
      return repo[u'slug']

  data = urllib.urlencode({
    "name" : name,
    "description": "Backup of Github Repo"
  })

  request = urllib2.Request("https://bitbucket.org/api/1.0/repositories", data)
  request.add_header("Authorization", "Basic %s" % base64string)
  response = urllib2.urlopen(request)
  repo = json.load(response)
  return repo[u'slug']

def handle_github_repo(name, clone_url):
  bitbucket_slug = find_or_create_bitbucket_repo("Backup - %s" % name)
  (status,output) = commands.getstatusoutput('./copy_repository.sh "%s" "%s" "%s"' % (name, clone_url, bitbucket_slug))
  if output.strip() != "":
    print output

def handle_all_github_repos():
  response = urllib2.urlopen('https://api.github.com/users/georf/repos')
  repos = json.load(response)

  for repo in repos:
    handle_github_repo(repo[u'name'], repo[u'clone_url'])

handle_all_github_repos()
