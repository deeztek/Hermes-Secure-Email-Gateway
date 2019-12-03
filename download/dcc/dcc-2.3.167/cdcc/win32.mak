# Makefile for cdcc for WIN32.

#   This assumes the Borland free command line tools FreeCommandLineTools.exe
#   available in 2004 at
#	http://www.borland.com/products/downloads/download_cbuilder.html
#   and elsewhere
#   or Microsoft's SDK

# Copyright (c) 2019 by Rhyolite Software, LLC
#
# Permission to use, copy, modify, and distribute this software without
# changes for any purpose with or without fee is hereby granted, provided
# that the above copyright notice and this permission notice appear in all
# copies and any distributed versions or copies are either unchanged
# or not called anything similar to "DCC" or "Distributed Checksum
# Clearinghouse".
#
# __________________________________________________
#
# THE SOFTWARE IS PROVIDED "AS IS" AND RHYOLITE SOFTWARE, LLC DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL RHYOLITE SOFTWARE, LLC
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# Rhyolite Software DCC 2.3.167-1.10 $Revision$


!include "../win32.makinc1"

TARGET	=cdcc
SRCS	=$(TARGET).c
OBJS	=$(SRCS:.c=.obj)

$(TARGET): $(OBJS) ../dcclib/dcclib.lib  ../clntlib/clntlib.lib
	$(CC) $(LFLAGS) $?

!include "../win32.makinc2"
