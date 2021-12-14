/**
* LOAD 
* setting, save....
* v 2.12.2
* 2013-2019
*/
void load_setup() {
  load_save(preference_path+"setting/defaultSetting.csv");
}


void load_autosave() {
  load_save(autosave_path);
}


void load_save(String path) {
  set_data_save_setting() ;
  load_data_GUI(path) ;
  load_saved_file_controller(path) ;
  apply_text_gui() ;
}






// LOAD INFO OBJECT from the PRESCENE
Table inventory_item_table;
int numGroup []; 
int [] item_rank, item_ID, item_group, item_camera_video_on_off, item_GUI_on_off;
String [] item_info, item_info_raw;
String [] item_name, item_author, item_version, item_pack, item_load_name, item_slider; 

Table shader_fx_bg_table;
String [] shader_fx_bg_name;
String [] shader_fx_bg_author;
String [] shader_fx_bg_slider;

Table shader_fx_table;
String [] shader_fx_name;
String [] shader_fx_author;
String [] shader_fx_slider;

Table shader_fx_mix_table;
String [] shader_fx_mix_name;
String [] shader_fx_mix_slider;

//BUTTON
int button_general_num;
int [] value_button_general; 


//Variable must be send to Scene
// statement on_off for the item group
int button_item_num;
boolean [] item_button_state;
int num_dd_item;
int [] value_button_item;
int [] pos_button_width_item, pos_button_height_item, width_button_item, height_button_item;




Inventory [] inventory ;
class Inventory {
  String name = "" ;
  boolean is = false ;
  Inventory(String name, boolean is) {
    this.name = name ;
    this.is = is;
  }

  public boolean is() {
    return is;
  }

  public void set_is(boolean is) {
    this.is = is;
  }

  public String get_name() {
    return name;
  }
}







/**
MANAGE DIALOGUE
v 0.0.5
*/
boolean load_dial_scene_is = false;
String slider_fx_filter_active_list = "";
void load_dial_scene() {
  if(load_dial_scene_is) {
  // if(load_dial_scene_is && frameCount%240 == 0) {
    Table dial_table = loadTable(preference_path +"dialogue_from_scene.csv","header");
    TableRow row = dial_table.getRow(0);
    slider_fx_filter_active_list = row.getString("fx slider active");
    load_dial_scene_is(false);
  }
}

void load_dial_scene_is(boolean is) {
  load_dial_scene_is = is;
}

boolean load_dial_scene_is() {
  return load_dial_scene_is;
}











/**
SETTING INFO BUTTON AND SLIDER
*/
void load_data_GUI(String path) {
  Table table = loadTable(path, "header");
  // create the var info for the slider we need
  int count_slider_background = 0;
  int count_slider_fx_filter = 0;
  int count_slider_fx_mix = 0;
  int count_slider_light = 0;
  int count_slider_sound = 0;
  int count_slider_sound_setting = 0;
  int count_slider_camera = 0;
  int count_slider_item = 0;

  for (TableRow row : table.rows()) {
    String s = row.getString("Type") ; 
    if(s.equals("Slider item a")) count_slider_item++ ;
    else if(s.equals("Slider item b")) count_slider_item++;
    else if(s.equals("Slider item c")) count_slider_item++;
    else if(s.equals("Slider item d")) count_slider_item++;
    else if(s.equals("Slider background")) count_slider_background++;
    else if(s.equals("Slider fx filter")) count_slider_fx_filter++; 
    else if(s.equals("Slider fx mix")) count_slider_fx_mix++; 
    else if(s.equals("Slider light")) count_slider_light++; 
    else if(s.equals("Slider sound")) count_slider_sound++;
    else if(s.equals("Slider sound setting")) count_slider_sound_setting++;  
    else if(s.equals("Slider camera")) count_slider_camera++; 
  }
  println("sliders background",count_slider_background);
  println("sliders fx filter",count_slider_fx_filter);
  println("sliders fx mix",count_slider_fx_mix);
  println("sliders light",count_slider_light);
  println("sliders sound",count_slider_sound);
  println("sliders sound setting",count_slider_sound_setting);
  println("sliders camera",count_slider_camera);
  println("sliders item",count_slider_item);

  info_button_general = new ivec3 [NUM_BUTTON_GENERAL];
  for(int i = 0 ; i < info_button_general.length ; i++) {
    info_button_general[i] = ivec3();
  }
  
  // BACKGROUND
  if(count_slider_background != NUM_SLIDER_BACKGROUND) {
    count_slider_background = NUM_SLIDER_BACKGROUND;
    printErr("info save SLIDER BACKGROUND is not the same than constant NUM_SLIDER_BACKGROUND, the constast has used instead, to prevent error");
  }
  cropinfo_slider_fx_bg = new Cropinfo[count_slider_background];
  for(int i = 0 ; i < count_slider_background ; i++) {
    cropinfo_slider_fx_bg[i] = new Cropinfo();
  }
  
  // FILTER FX
  if(count_slider_fx_filter != NUM_SLIDER_FX_FILTER) {
    count_slider_fx_filter = NUM_SLIDER_FX_FILTER;
    printErr("info save SLIDER FX is not the same than constant NUM_SLIDER_FX_FILTER, the constast has used instead, to prevent error");
  }
  cropinfo_slider_fx_filter = new Cropinfo[count_slider_fx_filter];
  for(int i = 0 ; i < count_slider_fx_filter ; i++) {
    cropinfo_slider_fx_filter[i] = new Cropinfo();
  }

  // MIX
  if(count_slider_fx_mix != NUM_SLIDER_FX_MIX) {
    count_slider_fx_mix = NUM_SLIDER_FX_MIX;
    printErr("info save SLIDER MIX is not the same than constant NUM_SLIDER_FX_MIX, the constast has used instead, to prevent error");
  }
  cropinfo_slider_fx_mix = new Cropinfo[count_slider_fx_mix];
  for(int i = 0 ; i < count_slider_fx_mix ; i++) {
    cropinfo_slider_fx_mix[i] = new Cropinfo();
  }
  
  // LIGHT
  if(count_slider_light != NUM_SLIDER_LIGHT) {
    count_slider_light = NUM_SLIDER_LIGHT;
    printErr("info save SLIDER LIGHT is not the same than constant NUM_SLIDER_LIGHT, the constast has used instead, to prevent error");
  }
  cropinfo_slider_light = new Cropinfo[count_slider_light];
  for(int i = 0 ; i < count_slider_light ; i++) {
    cropinfo_slider_light[i] = new Cropinfo();
  }
  
  // SOUND
  if(count_slider_sound != NUM_SLIDER_SOUND) {
    count_slider_sound = NUM_SLIDER_SOUND;
    printErr("info save SLIDER SOUND is not the same than constant NUM_SLIDER_SOUND, the constast has used instead, to prevent error");
  }
  cropinfo_slider_sound = new Cropinfo[count_slider_sound];
  for(int i = 0 ; i < count_slider_sound ; i++) {
    cropinfo_slider_sound[i] = new Cropinfo();
  }

  // SOUND SETTING
  if(count_slider_sound_setting != NUM_SLIDER_SOUND_SETTING) {
    count_slider_sound_setting = NUM_SLIDER_SOUND_SETTING;
    printErr("info save SLIDER SOUND SETTING is not the same than constant NUM_SLIDER_SOUND_SETTING, the constast has used instead, to prevent error");
  }
  cropinfo_slider_sound_setting = new Cropinfo[count_slider_sound_setting];
  for(int i = 0 ; i < count_slider_sound_setting ; i++) {
    cropinfo_slider_sound_setting[i] = new Cropinfo();
  }

  // CAMERA SETTING
  if(count_slider_camera != NUM_SLIDER_CAMERA) {
    count_slider_camera = NUM_SLIDER_CAMERA;
    printErr("info save SLIDER CAMERA is not the same than constant NUM_SLIDER_CAMERA, the constast has used instead, to prevent error");
  }
  cropinfo_slider_camera = new Cropinfo[count_slider_camera];
  for(int i = 0 ; i < count_slider_camera ; i++) {
    cropinfo_slider_camera[i] = new Cropinfo();
  }
  
  // ITEM
  cropinfo_slider_item = new Cropinfo[count_slider_item];
  for(int i = 0 ; i < count_slider_item ; i++) {
    cropinfo_slider_item[i] = new Cropinfo();
  }

  // create the var info for the item we need
  info_list_item_ID = new int [NUM_ITEM] ;
  
  // we don't count from the save in case we add object and this one has never use before and he don't exist in the data base
  info_button_item = new ivec3 [NUM_ITEM *BUTTON_ITEM_CONSOLE +BUTTON_ITEM_CONSOLE] ; 
  for(int i = 0 ; i < info_button_item.length ; i++) {
    info_button_item[i] = ivec3();
  }
}








































/**
* LOAD file
* v 2.2.0
* 2014-2019
*/
void load_setting_controller(File selection) {
  if (selection != null) {
    String loadPathControllerSetting = selection.getAbsolutePath();
    load_saved_file_controller(loadPathControllerSetting);
    INIT_INTERFACE = true;
    LOAD_SETTING = true;
  } 
}



// loadSave(path) read info from save file
void load_saved_file_controller(String path) {
  Table settingTable = loadTable(path, "header");
  // re-init the counter for the new loop
  int count_button_item = 0;
  int count_button_general = 0;
  int count_slider_general = 0;
  int count_slider_background = 0;
  int count_slider_fx_filter = 0;
  int count_slider_fx_mix = 0;
  int count_slider_light = 0;
  int count_slider_sound = 0;
  int count_slider_sound_setting = 0;
  int count_slider_camera = 0;
  int count_slider_item = 0;
  int count_item = 0;


  for (TableRow row : settingTable.rows()) {
    String s = row.getString("Type");
    // media
    if(s.equals("Media")){
      String media_path = row.getString("Path");
      add_media(media_path);
    }
    // button general
    if(s.equals("Button background")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }
    if(s.equals("Button curtain")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }

    if(s.equals("Button fx filter")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }

    if(s.equals("Button fx mix")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }


    if(s.equals("Button light ambient")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }
    if(s.equals("Button light 1")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }

    if(s.equals("Button light 2")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }

    if(s.equals("Button transient")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_general < info_button_general.length) {
        info_button_general[count_button_general].set(IDbutton,IDmidi,onOff);
      }
      count_button_general++;
    }

    // button item
    if(s.equals("Button item")){ 
      int IDbutton = row.getInt("ID button");
      int IDmidi = row.getInt("ID midi");
      int onOff = row.getInt("On Off");
      if(count_button_item < info_button_item.length) {
        info_button_item[count_button_item].set(IDbutton,IDmidi,onOff);
      } 
      count_button_item++; 
    }

    // slider background
    if(s.equals("Slider background")) {
      set_info_slider(row, "Slider background", cropinfo_slider_fx_bg[count_slider_background]);
      count_slider_background++;
    }

    // slider FX
    if(s.equals("Slider filter")) {
      set_info_slider(row, "Slider filter", cropinfo_slider_fx_filter[count_slider_fx_filter]);
      count_slider_fx_filter++;
    }  

    // slider MIX
    if(s.equals("Slider mix")) {
      set_info_slider(row, "Slider mix", cropinfo_slider_fx_mix[count_slider_fx_mix]);
      count_slider_fx_mix++;
    } 

    // slider light
    if(s.equals("Slider light")) {
      set_info_slider(row, "Slider light", cropinfo_slider_light[count_slider_light]);
      count_slider_light++;
    }

    // slider sound
    if(s.equals("Slider sound")) {
      set_info_slider(row, "Slider sound", cropinfo_slider_sound[count_slider_sound]);
      count_slider_sound++;
    }

    // slider sound setting
    if(s.equals("Slider sound setting")) {
      set_info_slider(row, "Slider sound setting", cropinfo_slider_sound_setting[count_slider_sound_setting]);
      count_slider_sound_setting++;
    }
    
    // slider camera
    if(s.equals("Slider camera")) {
      set_info_slider(row, "Slider camera", cropinfo_slider_camera[count_slider_camera]);
      count_slider_camera++;
    }

    // slider item
    if(s.equals("Slider item a")) {
      set_info_slider(row, "Slider item a", cropinfo_slider_item[count_slider_item]);
      count_slider_item++;
    }

    if(s.equals("Slider item b")) {
      set_info_slider(row, "Slider item b", cropinfo_slider_item[count_slider_item]);
      count_slider_item++;
    }

    if(s.equals("Slider item c")) {
      set_info_slider(row, "Slider item c", cropinfo_slider_item[count_slider_item]);
      count_slider_item++;
    }

    if(s.equals("Slider item d")) {
      set_info_slider(row, "Slider item d", cropinfo_slider_item[count_slider_item]);
      count_slider_item++;
    }

    
    // item list
    if(s.equals("Item")) {
      // security in case the developper remove item.
      // because if that's happen there is an Out Bound Exception
      if(count_item <  info_list_item_ID.length) {
        info_list_item_ID[count_item] = row.getInt("Item ID");
        String [] temp_item_info_split = split(item_info_raw[count_item +1], "/") ;
        int ID =  Integer.parseInt(temp_item_info_split[2]) ;
        boolean on_off = false ;
        if(row.getInt("Item On Off") == 1) {
          on_off = true; 
        } else {
          on_off = false;
        }

        inventory[ID].name = item_name[count_item +1]; 
        inventory[ID].set_is(on_off); 
        count_item++ ;
      }      
    }
  }
}


void set_info_slider(TableRow row, String name, Cropinfo info) {
  int id = row.getInt("ID slider");
  int id_midi = row.getInt("ID midi");
  
  int length_value = row.getInt("Value length");
  float [] value = new float[length_value];
  for(int i = 0 ; i < length_value ; i++) {
    value[i] = row.getFloat("Value slider "+i);

  }
 
  float min = row.getFloat("Min slider");
  float max = row.getFloat("Max slider");
  info.set_id(id).set_id_midi(id_midi).set_value(value).set_min(min).set_max(max);
  
}





















/**
SETTING SAVE
*/
boolean first_load;
void set_data() {
  if(INIT_INTERFACE) {
    set_button_inventory();
    if(!first_load) {
      set_inventory_item(false);
      first_load = true ;
    } else {
      set_inventory_item(true);
    }
    set_button_from_saved_file();
    set_slider_data_group();
    INIT_INTERFACE = false ;
  }
}



// Setting SLIDER from save
void set_slider_data_group() {
  for (int i = 0 ; i < NUM_SLIDER_BACKGROUND ; i++) {
    setting_data_slider(slider_adj_background[i],cropinfo_slider_fx_bg[i]);
    update_slider(slider_adj_background[i],cropinfo_slider_fx_bg);
  }

  for (int i = 0 ; i < NUM_SLIDER_FX_FILTER ; i++) {
    setting_data_slider(slider_adj_fx_filter[i],cropinfo_slider_fx_filter[i]);
    update_slider(slider_adj_fx_filter[i],cropinfo_slider_fx_filter);
  }

  for (int i = 0 ; i < NUM_SLIDER_FX_MIX ; i++) {
    setting_data_slider(slider_adj_fx_mix[i],cropinfo_slider_fx_mix[i]);
    update_slider(slider_adj_fx_mix[i],cropinfo_slider_fx_mix);
  }

  for (int i = 0 ; i < NUM_SLIDER_LIGHT ; i++) {
    setting_data_slider(slider_adj_light[i],cropinfo_slider_light[i]);
    update_slider(slider_adj_light[i],cropinfo_slider_light);
  }

  for (int i = 0 ; i < NUM_SLIDER_SOUND ; i++) {
    setting_data_slider(slider_adj_sound[i],cropinfo_slider_sound[i]);
    update_slider(slider_adj_sound[i],cropinfo_slider_sound);
  }

  for (int i = 0 ; i < NUM_SLIDER_SOUND_SETTING ; i++) {
    setting_data_slider(slider_sound_setting[i],cropinfo_slider_sound_setting[i]);
    update_slider(slider_sound_setting[i],cropinfo_slider_sound_setting);
  }

  for (int i = 0 ; i < NUM_SLIDER_CAMERA ; i++) {
    setting_data_slider(slider_adj_camera[i],cropinfo_slider_camera[i]);
    update_slider(slider_adj_camera[i],cropinfo_slider_camera);
  }

  for(int i = 0 ; i < NUM_SLIDER_ITEM ; i++) {
    setting_data_slider(slider_adj_item[i],cropinfo_slider_item[i]);
    update_slider(slider_adj_item[i],cropinfo_slider_item);
  }
}


// local method of set_slider_save()
void setting_data_slider(Slider slider, Cropinfo info) {
  slider.set_id_midi(info.get_id_midi());
  if(info.get_value() != null && slider.molette.length > info.get_value().length){
    float [] value;
    float step = 1. / (slider.molette.length +1);
    value = new float[slider.molette.length];
    for(int i = 0 ; i < value.length ;i++) {
      value[i] = (i+1)*step;
    }
    slider.set_value(value);
  } else if(info.get_value() != null) {
    slider.set_value(info.get_value());
  }

  if(slider instanceof Sladj) {
    Sladj sladj = (Sladj)slider;
    sladj.set_range(info.get_min(),info.get_max());
  }
}





//setting BUTTON from save
void set_button_from_saved_file() {
  // close loop to save the button statement, 
  // see void midiButtonManager(boolean saveButton)
  int rank = 0;
  // background
  if(info_button_general[rank].z == 1.0) button_bg.is(true) ; else button_bg.is(false);
  button_bg.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  // curtain
  if(info_button_general[rank].z == 1.0) button_curtain.is(true); else button_curtain.is(false);
  button_curtain.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  // FX FILTER
  for(int i = 0 ; i < NUM_BUTTON_FX_FILTER; i++) {
    if(info_button_general[rank].z == 1.0) button_fx_filter[i].is(true); else button_fx_filter[i].is(false);
    button_fx_filter[i].set_id_midi((int)info_button_general[rank].y); 
    rank++ ;
  }

  for(int i = 0 ; i < NUM_BUTTON_FX_MIX; i++) {
    if(info_button_general[rank].z == 1.0) button_fx_mix[i].is(true); else button_fx_mix[i].is(false);
    button_fx_mix[i].set_id_midi((int)info_button_general[rank].y); 
    rank++ ;
  }
  // light ambient
  if(info_button_general[rank].z == 1.0) button_light_ambient.is(true); else button_light_ambient.is(false);
  button_light_ambient.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  if(info_button_general[rank].z == 1.0) button_light_ambient_action.is(true); else button_light_ambient_action.is(false);
  button_light_ambient_action.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  //LIGHT ONE
  if(info_button_general[rank].z == 1.0) button_light_1.is(true); else button_light_1.is(false);
  button_light_1.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  if(info_button_general[rank].z == 1.0) button_light_1_action.is(true); else button_light_1_action.is(false);
  button_light_1_action.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  // LIGHT TWO
  if(info_button_general[rank].z == 1.0) button_light_2.is(true); else button_light_2.is(false);
  button_light_2.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  if(info_button_general[rank].z == 1.0) button_light_2_action.is(true); else button_light_2_action.is(false);
  button_light_2_action.set_id_midi((int)info_button_general[rank].y); 
  rank++ ;
  //SOUND
  for(int i = 0 ; i < NUM_BUTTON_TRANSIENT; i++) {
    if(info_button_general[rank].z == 1.0) button_transient[i].is(true); else button_transient[i].is(false);
    button_transient[i].set_id_midi((int)info_button_general[rank].y); 
    rank++ ;
  }
  

  /**
  can be simplify not sure it's necessary to use buttonRank
  */
  rank = 4; // start a 4 because we don't use the fourth for historic and bad reason
  int button_rank;
  for(int i = 1 ; i <= NUM_ITEM ; i++) {
    for (int j = 0 ; j < BUTTON_ITEM_CONSOLE ; j++) {
      button_rank = info_button_item[rank].x;
      // check if button rank is upper to zero, 
      // that's happen when a new item is add from Scene before save the setting
      if(button_rank > 0) {
        if(info_button_item[rank].z == 1.0 && button_rank == (i*BUTTON_ITEM_CONSOLE)+j) {
          button_item[button_rank].is(true);
        } else {
          button_item[button_rank].is(false); 
        }
        button_item[button_rank].set_id_midi((int)info_button_item[rank].y);
      }   
      rank++ ;
    }
  }
}















//LOAD text Interface
void apply_text_gui() {
  String lang[] ;
  lang = loadStrings(preference_path+"language.txt");

  String l = join(lang,"") ;
  int language = Integer.parseInt(l);
  Table gui_table;
  if(language == 0) {
    gui_table = loadTable(preference_path+"gui_info_fr.csv","header");
  } else if (language == 1) {
    gui_table = loadTable(preference_path+"gui_info_en.csv","header");
  } else {
    gui_table = loadTable(preference_path+"gui_info_en.csv","header");
  }


  int num_row = gui_table.getRowCount();
  for (int i = 0 ; i < num_row ; i++) {
    TableRow row = gui_table.getRow(i);
    String name = row.getString("name");
    int num = NUM_SLIDER_ITEM_BY_COL ;

    if(name.equals("general")) {
      // 
    } else if(name.equals("slider background")) {
      for(int k = 0 ; k < NUM_SLIDER_BACKGROUND ; k++) {
        slider_background_name[k] = row.getString("col "+k);
      } 
    } else if(name.equals("slider filter")) {
      for(int k = 0 ; k < NUM_SLIDER_FX_FILTER ; k++) {
        slider_fx_filter_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider mix")) {
      for(int k = 0 ; k < NUM_SLIDER_FX_MIX ; k++) {
        slider_fx_mix_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider light")) {
      for(int k = 0 ; k < NUM_SLIDER_LIGHT ; k++) {
        slider_light_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider sound")) {
      for(int k = 0 ; k < NUM_SLIDER_SOUND ; k++) {
        slider_sound_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider sound setting")) {
      for(int k = 0 ; k < NUM_SLIDER_SOUND_SETTING ; k++) {
        slider_sound_setting_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider camera")) {
      for(int k = 0 ; k < NUM_SLIDER_CAMERA ; k++) {
        slider_camera_name[k] = row.getString("col "+k);
      } 
    } 
    
    if(name.equals("slider item a")) {
      for(int k = 0 ; k < num ; k++) {
        slider_item_name[k] = row.getString("col "+k);
      }
    } else if(name.equals("slider item b")) {
      for(int k = 0 ; k < num ; k++) {
        slider_item_name[k +num] = row.getString("col "+k);
      }
    } else if(name.equals("slider item c")) {
      for(int k = 0 ; k < num ; k++) {
        slider_item_name[k +(num*2)] = row.getString("col "+k);
      }
    } else if(name.equals("slider item d")) {
      for(int k = 0 ; k < num ; k++) {
        slider_item_name[k +(num*3)] = row.getString("col "+k);
      }
    } 
  }
}





//IMPORT VIGNETTE
void set_import_pic_button() {
  //picto setting
  for(int i = 0 ; i < 4 ; i++) {
    pic_curtain[i] = loadImage("picto/picto_curtain_"+i+".png");
    // reset
    pic_reset_camera[i] = loadImage("picto/picto_camera_"+i+".png");
    pic_reset_item_on[i] = loadImage("picto/picto_item_selected_"+i+".png");
    pic_reset_fx[i] = loadImage("picto/picto_fx_"+i+".png");
    // misc
    pic_birth[i] = loadImage("picto/picto_birth_"+i+".png");
    pic_3D[i] = loadImage("picto/picto_3D_"+i+".png");
    //item
    picSetting[i] = loadImage("picto/picto_setting_"+i+".png") ;
    picSound[i] = loadImage("picto/picto_sound_"+i+".png") ;
    picAction[i] = loadImage("picto/picto_action_"+i+".png") ;
  }
  // load thumbnail
  int num = NUM_ITEM +1 ;
  OFF_in_thumbnail = new PImage[num] ;
  OFF_out_thumbnail = new PImage[num] ;
  ON_in_thumbnail = new PImage[num] ;
  ON_out_thumbnail = new PImage[num] ;
  for(int i=0 ;  i<num ; i++ ) {
    String className = ("0") ;
    if (item_load_name[i] != null) className = item_load_name[i] ;
    OFF_in_thumbnail[i] = loadImage("thumbnail/OFF_in/OFF_in_"+className+".png") ;
    if(OFF_in_thumbnail[i] == null) OFF_in_thumbnail[i] = loadImage("thumbnail/OFF_in/OFF_in_0.png") ;
    //
    OFF_out_thumbnail[i] = loadImage("thumbnail/OFF_out/OFF_out_"+className+".png") ;
    if(OFF_out_thumbnail[i] == null) OFF_out_thumbnail[i] = loadImage("thumbnail/OFF_out/OFF_out_0.png") ;
    // 
    ON_in_thumbnail[i] = loadImage("thumbnail/ON_in/ON_in_"+className+".png") ;
    if(ON_in_thumbnail[i] == null) ON_in_thumbnail[i] = loadImage("thumbnail/ON_in/ON_in_0.png") ;
    //
    ON_out_thumbnail[i] = loadImage("thumbnail/ON_out/ON_out_"+className+".png") ;
    if(ON_out_thumbnail[i] == null) ON_out_thumbnail[i] = loadImage("thumbnail/ON_out/ON_out_0.png") ;
  }
}