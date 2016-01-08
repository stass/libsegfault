LIB=	segfault
SRCS=	libsegfault.c

CFLAGS+=	-I/usr/local/include
LDFLAGS=	-L/usr/local/lib
LDADD=		-pthread -lunwind -lunwind-x86_64

WARNS=	6
SHLIB_MAJOR?=	0

.include <bsd.lib.mk>
