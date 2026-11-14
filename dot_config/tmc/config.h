/* SPDX-License-Identifier: GPL-2.0-only */
#ifndef CONFIG_H
#define CONFIG_H

#define COL_BORDER		8

#define COL_BORDER_FOCUS	5

#define COL_BAR_FG		8	/* the bar: dim text ... */
#define COL_BAR_BG		0	/* ... on the terminal's background */
#define COL_CUR_FG		0	/* the current window's label, messages and prompts: text ... */
#define COL_CUR_BG		8	/* ... on a dim block */
#define COL_BAR_ACCENT		13	/* mode, position, follow, session matches: accent, more prominent */
#define COL_NUMBERS		5	/* the client numbers shown by prefix o: accent */

#define COL_SELECT_FG		0
#define COL_SELECT_BG		4
#define COL_SELECT_BG_FOCUS	12

/* ---- keys -----------------------------------------------------------------------* /

/* Ctrl+space is the NUL byte */
#define PREFIX_KEY	0

#define CHORDS \
	{ PREFIX_KEY, A_SEND_PREFIX, 0 }, \
	{ '1', A_WINDOW, 0 }, { '2', A_WINDOW, 1 }, { '3', A_WINDOW, 2 }, \
	{ '4', A_WINDOW, 3 }, { '5', A_WINDOW, 4 }, { '6', A_WINDOW, 5 }, \
	{ '7', A_WINDOW, 6 }, { '8', A_WINDOW, 7 }, { '9', A_WINDOW, 8 }, \
	{ 'n', A_WINDOW_NEXT, 0 }, { 'N', A_WINDOW_PREV, 0 }, { '\t', A_WINDOW_LAST, 0 }, \
	{ 't', A_PANE_NEW, 0 }, { 'x', A_PANE_CLOSE, 0 }, { 'q', A_PANE_CLOSE, 0 }, \
	{ 'X', A_WINDOW_CLOSE, 0 }, { 'm', A_PANE_TO_WINDOW, 0 }, \
	{ 'j', A_FOCUS_NEXT, 0 }, { 'k', A_FOCUS_PREV, 0 }, \
	{ 'J', A_MOVE_NEXT, 0 }, { 'K', A_MOVE_PREV, 0 }, \
	{ 'h', A_MASTER_SHRINK, 0 }, { 'l', A_MASTER_GROW, 0 }, \
	{ 'H', A_COLUMN_SHRINK, 0 }, { 'L', A_COLUMN_GROW, 0 }, \
	{ 'i', A_NMASTER_MORE, 0 }, { 'p', A_NMASTER_FEWER, 0 }, \
	{ '\r', A_ZOOM, 0 }, { 'z', A_FULLSCREEN, 0 }, \
	{ 'S', A_BAR, 0 }, { 'R', A_RESIZE, 0 }, { 'r', A_RENAME, 0 }, \
	{ 'd', A_SESSION, 0 }, { 'D', A_DETACH, 0 }, \
	{ 'v', A_COPY, 0 }, { 'f', A_FOLLOW, 0 }, { 'o', A_OVERLAY, 0 }

/* Copy mode. */
#define COPY_KEYS \
	{ 'q', CA_EXIT, 0 }, \
	{ 'h', CA_LEFT, 0 }, { 'l', CA_RIGHT, 0 }, { 'j', CA_DOWN, 0 }, { 'k', CA_UP, 0 }, \
	{ '0', CA_LINE_START, 0 }, { '^', CA_LINE_FIRST, 0 }, { '$', CA_LINE_END, 0 }, \
	{ 'G', CA_BOTTOM, 0 }, { 'g', CA_G_PREFIX, 0 }, \
	{ 'H', CA_SCREEN_TOP, 0 }, { 'M', CA_SCREEN_MIDDLE, 0 }, { 'L', CA_SCREEN_BOTTOM, 0 }, \
	{ 0x15, CA_HALF_UP, 0 }, { 0x04, CA_HALF_DOWN, 0 },	/* Ctrl-u, Ctrl-d */ \
	{ 0x02, CA_PAGE_UP, 0 }, { 0x06, CA_PAGE_DOWN, 0 },	/* Ctrl-b, Ctrl-f */ \
	{ 0x19, CA_SCROLL_UP, 0 }, { 0x05, CA_SCROLL_DOWN, 0 },	/* Ctrl-y, Ctrl-e */ \
	{ 'w', CA_WORD, 'w' }, { 'W', CA_WORD, 'W' }, { 'b', CA_WORD, 'b' }, \
	{ 'B', CA_WORD, 'B' }, { 'e', CA_WORD, 'e' }, { 'E', CA_WORD, 'E' }, \
	{ '{', CA_PARAGRAPH, -1 }, { '}', CA_PARAGRAPH, 1 }, \
	{ 'f', CA_FIND, 'f' }, { 'F', CA_FIND, 'F' }, { 't', CA_FIND, 't' }, { 'T', CA_FIND, 'T' }, \
	{ ';', CA_FIND_REPEAT, ';' }, { ',', CA_FIND_REPEAT, ',' }, \
	{ '/', CA_SEARCH, '/' }, { '?', CA_SEARCH, '?' }, \
	{ 'n', CA_SEARCH_NEXT, 1 }, { 'N', CA_SEARCH_NEXT, -1 }, \
	{ 'v', CA_SELECT, 'v' }, { 'V', CA_SELECT, 'V' }, { 0x16, CA_SELECT, 'B' },	/* Ctrl-v: a block */ \
	{ 'o', CA_SELECT_SWAP, 0 }, \
	{ 'y', CA_YANK, 0 }, { '\r', CA_YANK, 0 }, { 'Y', CA_YANK_STAY, 0 }

#define STICKY_KEYS \
	{ 'h', A_MASTER_SHRINK, 0 }, { 'l', A_MASTER_GROW, 0 }, \
	{ 'H', A_COLUMN_SHRINK, 0 }, { 'L', A_COLUMN_GROW, 0 }, \
	{ 'i', A_NMASTER_MORE, 0 }, { 'p', A_NMASTER_FEWER, 0 }, \
	{ 'j', A_FOCUS_NEXT, 0 }, { 'k', A_FOCUS_PREV, 0 }, \
	{ 'J', A_MOVE_NEXT, 0 }, { 'K', A_MOVE_PREV, 0 }, { '\r', A_ZOOM, 0 }

#endif
