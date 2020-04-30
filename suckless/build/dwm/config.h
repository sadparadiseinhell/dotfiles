/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx = 3;   /* border pixel of windows */
static const unsigned int snap     = 32;  /* snap pixel */
static const unsigned int gappih   = 10;  /* horiz inner gap between windows */
static const unsigned int gappiv   = 10;  /* vert inner gap between windows */
static const unsigned int gappoh   = 10;  /* horiz outer gap between windows and screen edge */
static const unsigned int gappov   = 10;  /* vert outer gap between windows and screen edge */
static const int smartgaps         = 0;   /* 1 means no outer gap when there is only one window */
static const int showbar           = 1;   /* 0 means no bar */
static const int topbar            = 1;   /* 0 means bottom bar */
static const char *fonts[]         = { "Roboto:style=Bold:size=10" };
static const char dmenufont[]      = "monospace:size=10";

static char normfgcolor[]          = "#bbbbbb";
static char normbgcolor[]          = "#222222";
static char normbordercolor[]      = "#444444";
static char normfloatcolor[]       = "#005577";

static char selfgcolor[]           = "#eeeeee";
static char selbgcolor[]           = "#005577";
static char selbordercolor[]       = "#005577";
static char selfloatcolor[]        = "#005577";

static char urgfgcolor[]           = "#000000";
static char urgbgcolor[]           = "#000000";
static char urgbordercolor[]       = "#ff0000"; // NB: patch only works with border color for now
static char urgfloatcolor[]        = "#000000";

static
char *colors[][4] = {
	/*                fg            bg            border            float          */
	[SchemeNorm]  = { normfgcolor,  normbgcolor,  normbordercolor,  normfloatcolor },
	[SchemeSel]   = { selfgcolor,   selbgcolor,   selbordercolor,   selfloatcolor  },
	[SchemeUrg]   = { urgfgcolor,   urgbgcolor,   urgbordercolor,   urgfloatcolor },
};

/* tagging */
static const char *tags[]    = { "", "", "", "", "", "", "" };
static const char *tagsalt[] = { "1", "2", "3", "4", "5", "6", "7" };


static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 */
	/* class              instance  title   tags mask   switchtag   iscentered   isfloating   monitor */
	{ "feh",              NULL,     NULL,   0,          0,          0,           1,           -1 },
	{ "Sxiv",             NULL,     NULL,   0,          0,          0,           1,           -1 },
	{ "updates",          NULL,     NULL,   0,          0,          1,           1,           -1 },
	{ "Chromium",         NULL,     NULL,   1 << 0,     0,          0,           0,           -1 },
	{ "Subl3",            NULL,     NULL,   1 << 1,     1,          0,           0,           -1 },
	{ "nvim",             NULL,     NULL,   1 << 1,     1,          0,           0,           -1 },
	{ "ncmpcpp",          NULL,     NULL,   1 << 2,     1,          0,           0,           -1 },
	{ "mpv",              NULL,     NULL,   1 << 2,     1,          0,           0,           -1 },
	{ "discord",          NULL,     NULL,   1 << 3,     0,          0,           0,           -1 },
	{ "TelegramDesktop",  NULL,     NULL,   1 << 3,     1,          0,           0,           -1 },
	{ "Inkscape",         NULL,     NULL,   1 << 4,     1,          0,           0,           -1 },
	{ "Gimp",             NULL,     NULL,   1 << 4,     1,          0,           0,           -1 },
	{ "Transmission-gtk", NULL,     NULL,   1 << 6,     1,          0,           0,           -1 },
};



/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

#define FORCE_VSPLIT 1

/* Position of the monocle layout in the layouts variable, used by warp and fullscreen patches */
#define MONOCLE_LAYOUT_POS 2

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "|M|",      centeredmaster },
	{ "|||",      col },
	{ "[D]",      deck },
	{ "(@)",      spiral },
	{ "[\\]",     dwindle },
	{ "HHH",      grid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "###",      nrowgrid },
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },



/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]      = { "dmenu_run", NULL };
static const char *termcmd[]       = { "st", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "75x25", NULL };
static const char *browser[]       = { "chromium", NULL };
static const char *editor[]        = { "subl3", NULL };
static const char *nvim[]          = { "st", "-c", "'nvim'", "-e", "nvim", NULL };
static const char *fm[]            = { "pcmanfm", NULL };
static const char *ncmpcpp[]       = { "st", "-c", "'ncmpcpp'", "-e", "ncmpcpp", NULL };
static const char *menu[]          = { "/bin/sh", "-c", "$HOME/scripts/global-menu.sh", NULL };
static const char *scrotmenu[]     = { "/bin/sh", "-c", "$HOME/scripts/screenshot-menu.sh", NULL };
static const char *lock[]          = { "/bin/sh", "-c", "$HOME/scripts/lock.sh", NULL };
static const char *logout[]        = { "killall", "xinit", NULL };
static const char *play[]          = { "/bin/sh", "-c", "$HOME/scripts/musicctrl.sh play", NULL };
static const char *next[]          = { "/bin/sh", "-c", "$HOME/scripts/musicctrl.sh next", NULL };
static const char *prev[]          = { "/bin/sh", "-c", "$HOME/scripts/musicctrl.sh prev", NULL };
static const char *volup[]         = { "/bin/sh", "-c", "$HOME/scripts/volume.sh up", NULL };
static const char *voldown[]       = { "/bin/sh", "-c", "$HOME/scripts/volume.sh down", NULL };
static const char *mute[]          = { "/bin/sh", "-c", "$HOME/scripts/volume.sh mute", NULL };

static Key keys[] = {
	/* modifier                     key            function                argument */
	{ MODKEY,                       XK_p,          spawn,                  {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,     spawn,                  {.v = termcmd } },
	{ MODKEY,                       XK_grave,      togglescratch,          {.v = scratchpadcmd } },
	{ MODKEY|ShiftMask,             XK_b,          spawn,                  {.v = browser } },
	{ MODKEY|ShiftMask,             XK_s,          spawn,                  {.v = editor } },
	{ MODKEY|ShiftMask,             XK_v,          spawn,                  {.v = nvim } },
	{ MODKEY|ShiftMask,             XK_f,          spawn,                  {.v = fm } },
	{ MODKEY|ShiftMask,             XK_n,          spawn,                  {.v = ncmpcpp } },
	{ MODKEY|ShiftMask,             XK_p,          spawn,                  {.v = menu } },
	{ 0,                            XK_Print,      spawn,                  {.v = scrotmenu } },
	{ MODKEY|ShiftMask,             XK_l,          spawn,                  {.v = lock } },
	{ MODKEY|ShiftMask,             XK_x,          spawn,                  {.v = logout } },
	{ 0,                XF86XK_AudioPlay,          spawn,                  {.v = play } },
	{ 0,                XF86XK_AudioNext,          spawn,                  {.v = next } },
	{ 0,                XF86XK_AudioPrev,          spawn,                  {.v = prev } },
	{ 0,         XF86XK_AudioRaiseVolume,          spawn,                  {.v = volup } },
	{ 0,         XF86XK_AudioLowerVolume,          spawn,                  {.v = voldown } },
	{ 0,                XF86XK_AudioMute,          spawn,                  {.v = mute } },
	{ MODKEY,                       XK_b,          togglebar,              {0} },
	{ MODKEY,                       XK_j,          focusstack,             {.i = +1 } },
	{ MODKEY,                       XK_k,          focusstack,             {.i = -1 } },
	{ MODKEY,                       XK_i,          incnmaster,             {.i = +1 } },
	{ MODKEY,                       XK_d,          incnmaster,             {.i = -1 } },
	{ MODKEY,                       XK_h,          setmfact,               {.f = -0.05} },
	{ MODKEY,                       XK_l,          setmfact,               {.f = +0.05} },
	{ MODKEY,                       XK_Return,     zoom,                   {0} },
	{ MODKEY|Mod4Mask,              XK_u,          incrgaps,               {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,          incrgaps,               {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_i,          incrigaps,              {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,          incrigaps,              {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_o,          incrogaps,              {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,          incrogaps,              {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_6,          incrihgaps,             {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,          incrihgaps,             {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_7,          incrivgaps,             {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,          incrivgaps,             {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_8,          incrohgaps,             {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,          incrohgaps,             {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_9,          incrovgaps,             {.i = +5 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,          incrovgaps,             {.i = -5 } },
	{ MODKEY|Mod4Mask,              XK_0,          togglegaps,             {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,          defaultgaps,            {0} },
	{ MODKEY,                       XK_Tab,        view,                   {0} },
	{ MODKEY|ShiftMask,             XK_c,          killclient,             {0} },
	{ MODKEY|ShiftMask,             XK_q,          quit,                   {0} },
	{ MODKEY|ShiftMask,             XK_F5,         xrdb,                   {.v = NULL } },
	{ MODKEY,                       XK_t,          setlayout,              {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,          setlayout,              {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,          setlayout,              {.v = &layouts[2]} },
	{ MODKEY,                       XK_c,          setlayout,              {.v = &layouts[3]} },
	{ MODKEY,                       XK_s,          setlayout,              {.v = &layouts[8]} },
	{ MODKEY,                       XK_g,          setlayout,              {.v = &layouts[10]} },
	{ MODKEY,                       XK_space,      setlayout,              {0} },
	{ MODKEY|ShiftMask,             XK_space,      togglefloating,         {0} },
	{ MODKEY,                       XK_y,          togglefullscreen,       {0} },
	{ MODKEY,                       XK_0,          view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,                    {.ui = ~0 } },
	{ MODKEY,                       XK_comma,      focusmon,               {.i = -1 } },
	{ MODKEY,                       XK_period,     focusmon,               {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      tagmon,                 {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     tagmon,                 {.i = +1 } },
	{ MODKEY,                       XK_n,          togglealttag,           {0} },
	{ Mod4Mask|ControlMask,         XK_minus,      setborderpx,            {.i = -1 } },
	{ Mod4Mask|ControlMask,         XK_equal,      setborderpx,            {.i = +1 } },
	{ Mod4Mask,                     XK_equal,      setborderpx,            {.i = 0 } },
	{ MODKEY|ControlMask,           XK_comma,      cyclelayout,            {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period,     cyclelayout,            {.i = +1 } },
	TAGKEYS(                        XK_1,                                  0)
	TAGKEYS(                        XK_2,                                  1)
	TAGKEYS(                        XK_3,                                  2)
	TAGKEYS(                        XK_4,                                  3)
	TAGKEYS(                        XK_5,                                  4)
	TAGKEYS(                        XK_6,                                  5)
	TAGKEYS(                        XK_7,                                  6)
	TAGKEYS(                        XK_8,                                  7)
	TAGKEYS(                        XK_9,                                  8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask           button          function        argument */
	{ ClkLtSymbol,          0,                   Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,                   Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,                   Button2,        zoom,           {0} },
	{ ClkClientWin,         MODKEY,              Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,              Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,              Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,                   Button1,        view,           {0} },
	{ ClkTagBar,            0,                   Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,              Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,              Button3,        toggletag,      {0} },
};
