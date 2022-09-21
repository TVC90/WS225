import setuptools
from os import path


# read the contents of your README file
this_directory = path.abspath(path.dirname(__file__))


setuptools.setup(
    name="jupyter-pluto-proxy",
    packages=setuptools.find_packages(),
    classifiers=['Framework :: Jupyter'],
    install_requires=[
        'jupyter-server-proxy>=1.5.0'
    ],
    entry_points={
        'jupyter_serverproxy_servers': [
            'pluto = jupyter_pluto_proxy:setup_pluto',
        ]
    },
    package_data={
        'jupyter_pluto_proxy': ['icons/pluto.svg'],
    },
)
