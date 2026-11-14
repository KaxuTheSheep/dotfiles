#ifndef CONFIG_H
#define CONFIG_H

enum { ATTR_BOLD = 1, ATTR_DIM = 2, ATTR_ITAL = 4, ATTR_REV = 8 };
struct style { int fg, bg, attr; };

/* ---- connection -------*/
#define MPD_HOST      NULL   
#define MPD_PORT      0      
#define DB_POLL_MS    1000   /* how often to ask MPD whether its database changed */
#define TICK_MS       250    

/* ---- ART --------------------------------------------------------------------------- */
#define ART_ENABLE       1
#define ART_TMP          "/tmp/cmpc-art-src"    /* extracted image, no extension */
#define ART_FALLBACK_NAMES { "cover.jpg", "cover.png", "folder.jpg", "folder.png", NULL }
#define ART_MAX_PX       4000
#define ART_SCALE_FLAGS  "lanczos"           /* ffmpeg scaler: lanczos, bicubic, area, ... */
#define ART_POLL_MS      30
#define ART_SETTLE_MS    150   /* a new size must hold this long before the cover is rebuilt */
#define ART_LOG          "/tmp/cmpc-art.log"
#define ART_PX_PER_COL_FALLBACK  8
#define ART_PX_PER_ROW_FALLBACK  16

/* ---- visualiser (cava) ---------------------------------------------- */
#define VIS_ENABLE    1
#define VIS_MPD_FIFO  "/tmp/mpd.fifo"
#define CAVA_CMD      "cava"
#define CAVA_METHOD   "pipewire"   
#define CAVA_SOURCE   "auto"
#define VIS_FPS       30
#define VIS_BAR_W     2      /* cells per bar     */
#define VIS_BAR_GAP   1      /* cells between bars */

/* ---- colours ------------------------------------------------------------------- */
#define ST_TEXT       ((struct style){ 7, -1, 0})   /* text                                   */
#define ST_DIM        ((struct style){ 8, -1, 0})   /* dim: comments, disabled, inactive      */
#define ST_HEADER     ((struct style){-1, -1, ATTR_REV}) /* a section's header: reverse video, the theme's own two colours (D4) */
#define ST_HEADER_HI  ((struct style){ 0,  5, 0})   /* the header of the pane with input: text 0 on accent and focus */
#define ST_ACCENT     ((struct style){13, -1, 0})   /* accent, more prominent                 */
#define ST_TITLE      ((struct style){15, -1, 0})   /* text, more prominent                   */
#define ST_CURRENT    ((struct style){13, -1, 0})   /* the playing row: accent, more prominent (and its mark) */
#define ST_CURSOR     ((struct style){ 0, 12, 0})   /* the cursor row: text 0 on selection, in the focused pane (D8, D9) */
#define ST_CURSOR_OFF ((struct style){ 0,  4, 0})   /* ...and in a pane without the focus: slot 4 */
#define ST_UPNEXT     ((struct style){ 5, -1, 0})   /* up-next indent bar: accent             */
#define ST_SELECT     ((struct style){12, -1, 0})   /* multi-select mark: selection           */
#define ST_VIS_LO     ((struct style){ 5, -1, 0})   /* an activity ramp runs inside one pair  */
#define ST_VIS_MID    ((struct style){13, -1, 0})   /* ...and ends on text: 5, 13, 7          */
#define ST_VIS_HI     ((struct style){ 7, -1, 0})

/* ---- layout -------------------------------------------------------- */
#define LEFT_PCT      38     /* left pane width, percent of terminal   */
#define LEFT_MIN      34     /* ...but never narrower than this        */
#define NOWPLAY_H     5      /* the now-playing section: its header and four rows */
#define VIS_H         4      /* visualiser MINIMUM height, header included. The cover is a square; the visualiser gets the height left over, never less than this */
#define ART_MIN       3      /* the cover's section: never shorter than this, header included */
#define GUTTER_COL    1      /* between columns, and the margin inside a header */
#define GUTTER_GROUP  2      /* between groups of columns, and between the left column and the list */
#define GUTTER_ROW    1      /* blank rows between sections */
#define TRUNC_MARK    '~'    /* the last cell of a cut-off text, one cell wide (ASCII, D6; 0x2026 is the ellipsis) */
#define UPNEXT_BAR    "|"
#define SELECT_MARK   "#"   /* selected-for-playlist marker */
#define PLAY_MARK     ">"

/* ---- queue behaviour ----------------------------------------------- */
#define UP_NEXT_PRIO  1      /* MPD priority used to tag up-next songs */
#define START_MPD_REPEAT      1  /* turn MPD "repeat" on at startup    */
#define START_MPD_RANDOM_OFF  1  /* turn MPD "random" off at startup   */
#define START_SHUFFLE_LOOP    0  /* shuffle-loop mode on at startup    */
#define SHUFFLE_PCT   10
#define SHUFFLE_MIN   5
#define SHUFFLE_CAP   100
#define PROTECT_HEAD  3

/* ---- display ------------------------------------------------------- */
#define ARTIST_SEP    "//"   /* separator used in your tags (because Namida) */
#define ARTIST_JOIN   ", "   /* how it is shown                        */
#define VOLUME_STEP   5
#define SEEK_STEP     5      /* seconds                                */
#define MSG_MS        3000

/* file extensions (lowercase, no dot) treated as lossless */
#define LOSSLESS_EXTS { "flac", "wav", "alac", "ape", "wv", "aiff", "aif", "tta", "dsf", "dff", NULL }

#endif
