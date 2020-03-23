static const char norm_fg[]     = "#D8DEE9";
static const char norm_bg[]     = "#2E3440";
static const char norm_border[] = "#434C5E";

static const char sel_fg[]      = "#ECEFF4";
static const char sel_bg[]      = "#81A1C1";
static const char sel_border[]  = "#81A1C1";

static const char *colors[][3]  = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border  },  // focused win
};