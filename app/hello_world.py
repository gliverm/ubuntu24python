"""
Simple Python Hello World example using Docker

When running at the terminal virtual environment need the following:
export PYTHONPATH=${PYTHONPATH}:${PWD}
python3 ./app/hello_world.py

Example of formating project within virtual environment:
black ./app

Examples of running linting within virtual environment:
pylint --rcfile=setup.cfg app
bandit -r --ini setup.cfg
flake8 --config=setup.cfg app
black --check ./app

Makefile will have hints of how to run these commands in a CI/CD pipeline.

If a CI/CD pipeline is implemented, it is the centralized lint/test/build
enforcement of the project.  Pre-commits are helpful for only the basics
in a distributed non-enforced manner.
"""

from lib.base_logger import getlogger


def main():
    """Simple main function"""

    LOGGER.info("Hello world!!!")  # pylint: disable=possibly-used-before-assignment
    LOGGER.debug("Hello world!!!")
    LOGGER.error("Hello world!!!")
    LOGGER.warning("Hello world!!!")
    LOGGER.critical("Hello world!!!")
    LOGGER.trace("Hello world!!!")
    LOGGER.success("Hello world!!!")
    LOGGER.opt(colors=True).info("<green>Hello world!!!</green>")


print("Plain ole Hello world!!!")

if __name__ == "__main__":
    LOGGER = getlogger("HelloWorld")
    main()
