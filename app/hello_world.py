"""
Simple Python Hello World example using Docker
"""

from base_logger import getlogger

LOGGER = getlogger("HelloWorld")


LOGGER.info("Hello world!!!")
LOGGER.debug("Hello world!!!")
LOGGER.error("Hello world!!!")
LOGGER.warning("Hello world!!!")
LOGGER.critical("Hello world!!!")
LOGGER.trace("Hello world!!!")
LOGGER.success("Hello world!!!")
LOGGER.exception("Hello world!!!")
LOGGER.opt(colors=True).info("<green>Hello world!!!</green>")

print("Plain ole Hello world!!!")
