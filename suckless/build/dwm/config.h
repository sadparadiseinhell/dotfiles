/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 3;
static const unsigned int gappx     = 10;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Roboto:style=Bold:size=10" };
static const char dmenufont[]       = "Roboto:style=Bold:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
#include "/home/ma/.cache/wal/colors-wal-dwm.h"

/* tagging */
static const char *tags[] = { "", "", "", "", "", "" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class               instance    title       tags mask     isfloating   monitor */
	{ "Gimp",              NULL,       NULL,       1 << 4,       0,           -1 },
	{ "Firefox",           NULL,       NULL,       1 << 8,       0,           -1 },
	{ "Spotify",           NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Subl3",             NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Chromium",          NULL,       NULL,       1 << 0,       0,           -1 },
	{ "TelegramDesktop",   NULL,       NULL,       1 << 0,       0,           -1 },
	{ "mpv",               NULL,       NULL,       1 << 2,       0,           -1 },
	{ "feh",               NULL,       NULL,       0,            1,           -1 },
	{ "Sxiv",              NULL,       NULL,       0,            1,           -1 },
	{ "Transmission-gtk",  NULL,       NULL,       1 << 5,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

#include "gaplessgrid.c"
#include "bstack.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "<F>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[#]",      gaplessgrid },
	{ "[_]",      bstack },
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
static const char *dmenucmd[] = { "dmenu_run", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "75x25", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_grave,  togglescratch,  {.v = scratchpadcmd } },
	{ MODKEY|ShiftMask,             XK_f,      spawn,          SHCMD("pcmanfm") },
	{ 0,         XF86XK_AudioRaiseVolume,      spawn,          SHCMD("$HOME/scripts/refreshdwmbar.sh | pamixer -i 5") },
	{ 0,         XF86XK_AudioLowerVolume,      spawn,          SHCMD("HOME/scripts/refreshdwmbar.sh  | pamixer -d 5") },
	{ 0,                XF86XK_AudioMute,      spawn,          SHCMD("$HOME/scripts/refreshdwmbar.sh | pamixer -t") },
	{ 0,                            XK_Print,  spawn,          SHCMD("$HOME/scripts/screenshot-menu.sh") },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("$HOME/scripts/lock.sh") },
	{ 0,                XF86XK_AudioPlay,      spawn,          SHCMD("mpc toggle") },
	{ 0,                XF86XK_AudioNext,      spawn,          SHCMD("mpc next") },
	{ 0,                XF86XK_AudioPrev,      spawn,          SHCMD("mpc prev") },
	{ MODKEY|ShiftMask,             XK_p,      spawn,          SHCMD("$HOME/scripts/global-dmenu.sh") },
	{ MODKEY|ShiftMask,             XK_n,      spawn,          SHCMD("st -e ncmpcpp") },
	{ MODKEY|ShiftMask,             XK_r,      spawn,          SHCMD("st -e ranger") },
	{ MODKEY|ShiftMask,             XK_v,      spawn,          SHCMD("st -e vim") },
	{ ControlMask,                  XK_Alt_L,  spawn,          SHCMD("$HOME/scripts/refreshdwmbar.sh") },
	{ MODKEY|ShiftMask,             XK_b,      spawn,          SHCMD("chromium") },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_u,      setlayout,      {.v = &layouts[4]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -5 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +5 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_x,      spawn,          SHCMD("$(killall xinit)") },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

