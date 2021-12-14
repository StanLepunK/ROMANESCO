/**
ROMANESCO
romanesco dui rendering
2013–2021
release 34
*/

/**
* WARNING
* Is not possible to use method print when the prescene is used because the rendering prescene and scene is from the same sketch
* Using in print in DEV_MOD cause a crash.
*/

/**
2015 may 15_000 lines of code
2016 may 27_500 lines of code
2017 March 40_000 lines of code
2019 August 65_000 lines of code
2019 November 68_000 lines of code
*/



/**
BUG with warp on MacBook Pro 2018 or HighSierra / Mojave
*/


// DEVELOPER SETTING
boolean DEBUG_MODE = true;
boolean USE_LAYER = false; // cause a bug when the  shader effect is used
boolean DEV_MODE = true; // inter alia, path preferences folder, curtain
String IAM = "prescene";
boolean LIVE = false;
boolean FULL_RENDERING = true;

// PRESCENE LIVE
// boolean DEBUG_MODE = true;
// boolean USE_LAYER = true;
// boolean DEV_MODE = true; // inter alia, path preferences folder, curtain
// String IAM = "prescene";
// boolean LIVE = true;
// boolean FULL_RENDERING = false;

// SCENE LIVE
// boolean DEBUG_MODE = true;
// boolean USE_LAYER = true;
// boolean DEV_MODE = true; // inter alia, path preferences folder, curtain
// String IAM = "scene";
// boolean LIVE = false;
// boolean FULL_RENDERING = true;
































/**
* EXPORT SETTING
* Here you can choice between the three common rendering mode
*/
// PRESCENE FULL RENDERING
// APP: prescene_## > change for size(124,124)
// boolean USE_LAYER = false;
// boolean DEV_MODE = false;  // inter alia, path preferences folder, curtain
// String IAM = "prescene";
// boolean LIVE = false;
// boolean FULL_RENDERING = true;
// boolean DEBUG_MODE = false;


// PRESCENE LIVE PREVIEW
// APP: prescene_##_live > change for size(124,124) in settings()
// boolean USE_LAYER = false;
// boolean DEV_MODE = false; // inter alia, path preferences folder, curtain
// String IAM = "prescene";
// boolean LIVE = true;
// boolean FULL_RENDERING = false;
// boolean DEBUG_MODE = false;


// SCENE LIVE
// for the scene live export, two export set in void settings() 
// APP: scene_##_live_fullscreen  > change for  fullScreen() in settings()
// APP: scene_##_live > change for size(124,124) in settings()
// boolean USE_LAYER = false;
// boolean DEV_MODE = false; // inter alia, path preferences folder, curtain
// String IAM = "scene";
// boolean LIVE = false; 
// boolean FULL_RENDERING = true;
// boolean DEBUG_MODE = false;

















/* 
Use false when you want:
used sound & maximum possibility of the object
*/
boolean USE_SOUND = true; 
boolean MIROIR = false;

boolean FULL_SCREEN = false;
boolean TABLET = false; // now tablet library don't work in OPENGL renderer
/**
LIVE must change from the launcher, the info must be write in the external loading preference app
*/

// DEV_MODE : rank folder, curtain, OSC thread




void settings() {
	size(1000,600,P3D); // DEV MODE PARAM
	init_rope();
	
	// EXPORTING PARAM 
	// size(124,124,P3D);

	// fullScreen(P3D);
	// FULL_SCREEN = true;

	// syphon_settings();

	if(IAM.equals("prescene")) {
		scene = false;
		prescene = true;
	} else if(IAM.equals("scene")) {
		OPEN_APP = true;
		scene = true;
		prescene = false;
	}
}



PApplet p5;
void setup() {
	p5 = this;
	path_setting();
	// shader_folder_filter(preference_path+"shader/filter/");
	load_save(preference_path+"setting/defaultSetting.csv");
	media_init_collection();
	version();
	set_system_specification();
	OSC_setup();
 
	int num_layer = 4;
	/**
	* layer 0 / first : background
	* layer 1 : item 2D
	* layer 2 : item 3D
	* last layer : info
	*/
	int frame_rate = 60;
	display_setup(frame_rate,num_layer); // the int value is the frameRate

	romanesco_build_item();

	create_variable();

	camera_setup();

	if(IAM.equals("prescene")){
		prescene_setup(); 
		// leapmotion_setup();
	} else if(IAM.equals("scene")) {
		scene_variables_setup();
	}

	color_setup();
	// syphon_setup();

	init_variable_item_min_max();
	init_variable_item();
	init_slider_variable_world();
	load_system_font();
	create_font();
	init_font();
	update_font_item();
	
	if(USE_SOUND) sound_setup();

	light_position_setup();
	light_setup();

	init_fx_filter();
	init_background();
	init_fx_background();
}






boolean init_app;
void draw() {
	if(init_app) { 
		String title = nameVersion + " " +prettyVersion+"."+version+ " | "+ IAM + " | FPS: "+round(frameRate);
		if(MIROIR) title = nameVersion + " " +prettyVersion+"."+version+ " | "+ "miroir" + " | FPS: "+round(frameRate);
		surface.setTitle(title);
		if(!FULL_SCREEN) {
			update_window_location();
		}
		// script
		if(frameCount%180 == 0) {
			rom_manager.historic();
			int size = rom_manager.historic_size();
			//rom_manager.print_historic();
		}

		romanesco();

		if(width == 1 || height == 1) {
			printErr("width:",width,"heigh:",height, "this window size is not usable the process is stoped,\nplease set preference size via the launcher or directly in file sceneProperty.csv");
		}
	} else {
		if(FULL_RENDERING) {
			shader_setup();
		}
		init_app = items_loaded_is(); 
	}
}

void romanesco() {
	init_romanesco();
	// syphon_draw();
	if(USE_SOUND) {
		sound_draw();
	}
	OSC_update();
	update_raw_item_value();

	if(IAM.equals("prescene")) {
		update_command();
		// leapmotion_update();
	} 
  
  show_is();
	rendering();

	screenshot();
	puppet_master(false); // use to reset puppet for the force field
	update_slider_ref();
	media_update(180);
	change_slider_ref();
	load_dial_controller();
	reset_button_alert();

	if(IAM.equals("scene")) {
		init_value_temp_prescene();
		if (!miroir_on_off && OPEN_APP) {
			opening();
		}
	} else if(IAM.equals("prescene")) {
		device_update();
		if(LIVE) {
			if(send_message_is()) {
				OSC_send();
				send_message(false);
			}
		}
	}

	
	if(IAM.equals("prescene")) {
		// change to false if the information has be sent to Scene...but how ????
		key_false();
	}

	// post_rendering();

	// mask
	if(FULL_RENDERING) {
		mask();
	}

	// cursor
	if(IAM.equals("scene")) {
		if(set_mask_is() || displayInfo) {
			cursor();
		} else {
			noCursor();
		}
	}
}



















/**
EVENT
v 2.0.0
2014-2018
*/
void keyPressed() {
	if (key == 'i') displayInfo = !displayInfo;
	if (key == 'g') show_info_camera = !show_info_camera;

	keyPressed_event();

	keyPressed_mask_set('m','M','N');
	keyPressed_mask_hide('H');
	keyPressed_mask_save('S');
	keyPressed_mask_load('L');
	keyPressed_mask_delete_bloc(BACKSPACE, 'D');

	warp_force_keyPressed('W');
}

void keyReleased() {
	keyReleased_event();
	keyReleased_event_camera('c');
}

void mousePressed() {
	mousePressed_event();
	mousePressed_event_mask();
}

void mouseReleased() {
	mouseReleased_event();
	mouseReleased_event_mask();
}

// Mouse in or out of the sketch
public void mouseEntered(MouseEvent e) {
	mouseEntered_event(e);
}

public void mouseExited(MouseEvent e) {
	mouseExited_event(e);
}

void mouseWheel(MouseEvent e) {
	mouseWheel_event(e);
}



