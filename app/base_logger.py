"""
Example of a Base logger for an app.  
"""

import sys
from loguru import logger

singlelogger = None


def getlogger(name: str = "DefaultName", level="DEBUG") -> logger:
    """Initialize logging for app returning logger."""
    global singlelogger

    if singlelogger is None:
        logobj = logger
        logobj.remove()
        logger_format = (
            "<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | "
            f"{name} | "
            "<level>{level: <8}</level> | "
            "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> | "
            "<level>{message}</level>"
        )
        logobj.add(
            sys.stderr,
            level=level,
            format=logger_format,
            colorize=None,
            serialize=False,
        )
        singlelogger = logobj

    return singlelogger
