# Configuration file for ipython-notebook.
from os import environ, remove

c = get_config()


#------------------------------------------------------------------------------
# NotebookApp configuration
#------------------------------------------------------------------------------

# NotebookApp will inherit config from: BaseIPythonApplication, Application

# The IPython password to use i.e. "datajoint".
c.NotebookApp.password = u'sha1:06a636d59f35:83a05583e2737b24c070f5a16355486f9e1b8fb3'

# Allow root access.
c.NotebookApp.allow_root = True

# The IP to serve on.
c.NotebookApp.ip = u'0.0.0.0'

# The Port to serve on.
c.NotebookApp.port = 8888

c.NotebookApp.default_url = '/tree'

c.NotebookApp.notebook_dir = '/home/dja'

c.FileContentsManager.root_dir = '/home/dja'
