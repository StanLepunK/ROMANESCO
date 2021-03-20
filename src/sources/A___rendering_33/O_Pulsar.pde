/**
* Pulsar
* 2018-2021
* v 0.1.2
*/

//object one
class Pulsar extends Romanesco {
  Cloud_3D pulsar;

  public Pulsar() {
    item_name = "Pulsar" ;
    item_author  = "Stan le Punk";
    item_version = "version 0.1.2";
    item_pack = "Base 2018-2021";
    item_costume = "ellipse/triangle/rect/cross/pentagon/flower/star/point";
    item_mode = "nothing/cyclus/heart/ring cyclus/ring heart/helmet cyclus/helmet heart" ;
  
    hue_fill_is = true;
    sat_fill_is = true;
    bright_fill_is = true;
    alpha_fill_is = true;
    hue_stroke_is = true;
    sat_stroke_is = true;
    bright_stroke_is = true;
    alpha_stroke_is = true;
    thickness_is = true;
    size_x_is = true;
    size_y_is = true;
    size_z_is = true;
    // diameter_is = true;
    canvas_x_is = true;
    // canvas_y_is = true;
    // canvas_z_is = true;

    // frequence_is = true;
    speed_x_is = true;
    speed_y_is = true;
    speed_z_is = true;
    // spurt_x_is = true;
    // spurt_y_is = true;
    // spurt_z_is = true;
    dir_x_is = true;
    dir_y_is = true;
    dir_z_is = true;
    // jit_x_is = true;
    //jit_y_is = true;
    // jit_z_is = true;
    swing_x_is = true;
    // swing_y_is = true;
    // swing_z_is = true;

    quantity_is = true;
    // variety_is = true;
    // life_is = true;
    // flow_is = true;
    // quality_is = true;
    area_is = true;
    // angle_is = true;
    // scope_is = true;
    // scan_is = true;
    // align_is = true;
    // repulsion_is = true;
    // attraction_is = true;
    // density_is = true;
    // influence_is = true;
    // calm_is = true;
    // spectrum_is = true;
  }

  
  //SETUP
  void setup() {
    set_item_pos(width/2, height/2,0);
  }
  //DRAW
  int num_ref ;
  void draw() {
    float num_temp = get_quantity().value();
    num_temp = num_temp *num_temp *num_temp;
    int num = int(5 + (5000 *num_temp));
    if(pulsar == null || num_ref != num) {
      pulsar = new Cloud_3D(p5, num,P3D,r.ORDER,r.POLAR);
      num_ref = num;
    } else {
      pulsar();
    }
  }


  void pulsar() {
    int radius = (int)get_canvas_x().value();

    vec3 speed = get_speed();
    speed.pow(3).div(2);

    // cloud_3D.ring(.01, false);
    // cloud_3D.helmet(.005, false);
    float ratio_size = map(get_area().value(),get_area().min(),get_area().max(),0,1);
    pulsar.size(get_size());
    // cloud_3D.size((height/4) *abs(sin(frameCount *.01)));
    // cloud_3D.orientation_y(map(mouseY,0,height,-PI,PI));
    // cloud_3D.angle(frameCount *.01);
    aspect(get_fill(), get_stroke(), get_thickness().value());
    



    // rendering


    if(motion_is()) {
      pulsar.rotation_x(speed.x,false);
      pulsar.rotation_y(speed.y,false);
      pulsar.rotation_z(speed.z,false);
      pulsar.orientation(get_dir());

      mode();
      float swing = get_swing_x().normal() *get_swing_x().normal();
      swing = map(swing,0,1,0,80);

      pulsar.set_tempo((int)swing);
      if(!sound_is()) {

        // pulsar.set_tempo(80);   
      } else {
        // pulsar.set_tempo((int)tempo[ID_item]); 
        float ratio_transient = all_transient(ID_item);
        radius *= (ratio_transient *.2);
      }

    } else {
      pulsar.set_behavior("RADIUS"); // nothing
    }
    pulsar.set_radius(radius);

    vec3 pos = vec3();
    
    pulsar.pos(pos);
    pulsar.update();

    pulsar.costume_ratio_size(ratio_size);
    pulsar.costume(get_costume());
    pulsar.show();
  }



  void mode() {
    if(get_mode_id() == 0) {
      pulsar.set_behavior("RADIUS"); // nothing
    } else if(get_mode_id() == 1) {
      pulsar.set_behavior("SIN"); // cyclus

    } else if(get_mode_id() == 2) {
      pulsar.set_behavior("SIN_POW_SIN"); // heart

    } else if(get_mode_id() == 3) {
      pulsar.set_behavior("SIN"); // cyclus ring
      pulsar.ring(.01, false);
    } else if(get_mode_id() == 4) {
      pulsar.set_behavior("SIN_POW_SIN"); // heart ring
      pulsar.ring(.01, false);
    } else if(get_mode_id() == 5) {
      pulsar.set_behavior("SIN"); // cyclus helmet
      pulsar.helmet(.01, false);
    } else if(get_mode_id() == 6) {
      pulsar.set_behavior("SIN_POW_SIN"); // hear helmet
      pulsar.helmet(.01, false);
    }
  }
}





  