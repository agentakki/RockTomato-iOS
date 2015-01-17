#include <pebble.h>

Window *my_window;
TextLayer *text_layer;
TextLayer *timer_layer;

static AppTimer* timer = NULL;

static double startTime = 0;
static double pausedDuration = 0;
static double pausedTime = 0;
static bool timer_on = false;

//Standard times
static int work_duration = 25;
static int brk_duration = 5;

//functions
static void select_click_handler(ClickRecognizerRef recognizer, void *context);
static void select_reset_handler(ClickRecognizerRef recognizer, void *context);
static void click_config_provider(void *context);
  
static void start_timer(void);
static void pause_timer(void* data);
static void handle_timer(void* data);
static void update_timer(void* data); 
static void end_timer(void);

static void handle_init(void);
static void handle_deinit(void);
static void window_load(Window *window);
static void window_unload(Window *window);

//function definitions
static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  if(timer_on) {
    pause_timer(NULL);
  }
  else start_timer();
}

static void select_reset_handler(ClickRecognizerRef recognizer, void *context) {
  if(timer_on)
    end_timer();
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_long_click_subscribe(BUTTON_ID_SELECT, 500, (ClickHandler)select_reset_handler, NULL);
}

static void start_timer(void) {
  if(pausedDuration != 0) {
    timer_on = true;
    text_layer_set_text(text_layer, "Start after P");
    startTime = pausedTime + pausedDuration;
    timer = app_timer_register(1000, handle_timer, NULL);
  }
  else {
    timer_on = true;
    text_layer_set_text(text_layer, "Start");
    startTime = (double)time(NULL);
    timer = app_timer_register(1000, handle_timer, NULL);
  }
}

static void pause_timer(void* data) {
  if(timer_on) {
    timer_on = false;
    pausedTime = (double)time(NULL);
    text_layer_set_text(text_layer, "Pause after S");
    timer = app_timer_register(1000, pause_timer, NULL);
  }
  else {
    pausedDuration = (double)time(NULL) - pausedTime;
    //startTime = pausedTime + pausedDuration;
    text_layer_set_text(text_layer, "Pauseing");
    timer = app_timer_register(1000, pause_timer, NULL);
  }
}

static void handle_timer(void* data) {
  timer = app_timer_register(1000, handle_timer, NULL);
  text_layer_set_text(text_layer, "handling");
  update_timer(NULL);
}

static void update_timer(void* data) {
  static char timeText[] = "00:00";
  
  double totalDuration = (double)time(NULL) - startTime;
  int seconds = (int)totalDuration % 60;
  int minutes = (int)totalDuration / 60 % 60;
  
  snprintf(timeText, 6, "%02d:%02d", minutes, seconds);
  text_layer_set_text(timer_layer, timeText);
  text_layer_set_text(text_layer, "time");
  
  if(seconds > 5) {
    end_timer();
    vibes_double_pulse();
    return;
  }
  
}

static void end_timer(void) {
  text_layer_set_text(text_layer, "end time");
  pausedDuration = 0;
  pausedTime = 0;
  startTime = 0;
  app_timer_cancel(timer);
  timer = NULL;
}

static void handle_init(void) {
  my_window = window_create();
  //window_set_background_color(my_window, GColorBlack);
  window_set_fullscreen(my_window, false);
  
  window_set_click_config_provider(my_window, click_config_provider);

  window_set_window_handlers(my_window, (WindowHandlers) {
    .load = window_load,
    .unload = window_unload,
  });
  text_layer = text_layer_create(GRect(0, 0, 144, 20));
  text_layer_set_text(text_layer, "Start timer");
  window_stack_push(my_window, true);
}

static void handle_deinit(void) {
  text_layer_destroy(text_layer);
  window_destroy(my_window);
}

static void window_load(Window *window) {
  Layer *root_layer = window_get_root_layer(window);
  
  text_layer = text_layer_create(GRect(5, 25, 105, 35));
 // text_layer_set_text_color(text_layer, GColorWhite);
  text_layer_set_text(text_layer, "RockTomatoe");
  layer_add_child(root_layer, (Layer*)text_layer);
  
  timer_layer = text_layer_create(GRect(50, 100, 50, 35));
  text_layer_set_text(timer_layer, "25:00");
  layer_add_child(root_layer, (Layer*)timer_layer);
}

static void window_unload(Window *window) {
  text_layer_destroy(text_layer);
}

int main(void) {
  handle_init();
  app_event_loop();
  handle_deinit();
}
