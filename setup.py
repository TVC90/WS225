import setuptools

setuptools.setup(
  name="plutoserver",
  packages=['plutoserver'],
  package_dir={'plutoserver': 'plutoserver'},
  package_data={'plutoserver': ['icons/pluto-logo.svg']},
  entry_points={
      'jupyter_serverproxy_servers': [
          # name = packagename:function_name
          'pluto = plutoserver:setup_plutoserver',
      ]
  },
  install_requires=['jupyter-server-proxy @ git+http://github.com/fonsp/jupyter-server-proxy@3a58aa5005f942d0c208eab9a480f6ab171142ef'],
)

# because this is a demo of Pluto, we add some popular packages to the global package env and precompile
import os
os.system('julia -e "import Pkg; Pkg.add([\\"Markdown\\", \\"InteractiveUtils\\", \\"Documenter\\", \\"Distributions\\", \\"GLMakie\\", \\"PlutoUI\\",\\"LinearAlgebra\\"], \\"HypertextLiteral\\"); Pkg.precompile()"')

