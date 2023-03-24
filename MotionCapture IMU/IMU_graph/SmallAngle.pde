class orient {
  // orient is a rotatable coordinate system
  PVector ui;
  PVector uj;
  PVector uk;
  orient() {
    // initialize coordinate axis
    ui = new PVector(1, 0, 0);
    uj = new PVector(0, 1, 0);
    uk = new PVector(0, 0, 1);
  }
  void spin(PVector phi) {
    // this method rotates the coordinates
    // around an axis by an angle
    ui = handleturn(ui, phi);
    uj = handleturn(uj, phi);
    uk = handleturn(uk, phi);
  }
  void restore() {
    // repairs the orthogonality of the axis
    uk = ui.cross(uj);
    uj = uk.cross(ui);
    ui.normalize();
    uj.normalize();
    uk.normalize();
  }
  PVector toOri(PVector w){
    // rotates a world coordinate into a orient coordinate
    PVector o = new PVector();
    o.x = w.x * ui.x + w.y * ui.y + w.z * ui.z;
    o.y = w.x * uj.x + w.y * uj.y + w.z * uj.z;
    o.z = w.x * uk.x + w.y * uk.y + w.z * uk.z;
    return o;
  }
  PVector toWorld(PVector o){
    // rotates a orient coordinate into a world coordinate
    PVector w = new PVector();
    w.x = ui.x * o.x + uj.x * o.y + uk.x * o.z;
    w.y = ui.y * o.x + uj.y * o.y + uk.y * o.z;
    w.z = ui.z * o.x + uj.z * o.y + uk.z * o.z;
    return w;
  }
  PVector handleturn(PVector r, PVector w) {
    // this method constrains the turn method to within
    // a domain for wich it will return a valid solution
    PVector handled = r;
    if ((w.mag() != 0) && (r.mag() != 0)) {
      // turn cant handle vectors with zero magnitude
      PVector r2 = new PVector();
      r2.x = r.x;
      r2.y = r.y;
      r2.z = r.z;
      PVector w2 = new PVector();
      w2.x = w.x;
      w2.y = w.y;
      w2.z = w.z;
      r2.normalize();
      w2.normalize();
      if (r2.dot(w2) != 1) {
        // there's no point rotating if they are parallel
        handled = turn(r, w);
      }
    }
    return handled;
  }
  PVector turn(PVector r, PVector w) {
    // since it is only acurate for small angle
    // constrain the angular step to PI/8
    float dw = PI/8;
    int divisions;
    // cut w into a bunch of small angles
    if (w.mag() > dw) {
      divisions = ceil(w.mag() / dw);
    } else {
      divisions = 1;
    }
    // i used .x=.x befor i knew to use get()
    PVector uw = new PVector();
    uw.x = w.x;
    uw.y = w.y;
    uw.z = w.z;
    uw.normalize();// unit vector for the axis of rotation
    // remove the component parallel to the axis of rotation
    PVector along = PVector.mult(uw, uw.dot(r));
    PVector rprime = PVector.sub(r, along);
    // phi is the small angle and axis
    PVector phi = PVector.div(w, divisions);
    // do a bunch of small turns
    for (int i=1; i<=divisions; i++) {
      rprime = dturn(rprime, phi);
    }
    // restore the component parallel to the axis of rotation
    return PVector.add(rprime, along);
  }
  PVector dturn(PVector rprime, PVector phi) {
    // This will be dificult to describe without a picture.
    // Just imagine where the vector is starting and where
    // it is trying to get to.
    PVector o2 = PVector.div(phi, 2);// small angle over two
    // translate r along a vector perpendicular to the axis
    // by a magnitude proportional to the angle
    PVector a = PVector.add(rprime, o2.cross(rprime));
    PVector ua = a;
    ua.normalize();// unit vector representing one half turn
    // find a vector which points from 'r' to 'ua' such that
    // 'ua' has a magnitude equal to the component of 'r'
    // which is parralel to 'a'
    PVector b = PVector.mult(PVector.sub(rprime,
    PVector.mult(ua, ua.dot(rprime))), -1);
    // add 2*b to r, this is the new r
    // r has the same magnitude as before :)
    return PVector.add(rprime, PVector.mult(b, 2));
  }
}
class orientation {
  // I have since revized the above method to be more consise.
  // There is also a correction for the small angle approxamation
  // which makes it acurate for arbitrarily large angles.
  PVector[] axis;
  orientation() {
    // initialize axis
    axis = new PVector[3];
    axis[0] = new PVector(1, 0, 0);
    axis[1] = new PVector(0, 1, 0);
    axis[2] = new PVector(0, 0, 1);
  }
  void rotate(PVector w) {
    // rotates the entire coordinate system
    // around an axis parallel to w
    // and by an angle which is the magnitude of w
    for (int i=0;i<3;i++) {
      spin(axis[i], w);
    }
  }
  void spin(PVector r, PVector w) {
    // ensure that both vectors are not zero magnitude
    if ((w.x!=0||w.y!=0||w.z!=0)&&(r.x!=0||r.y!=0||r.z!=0)) {
      // w2 is corrected so the method works dispite small angle
      float w2 = tan(w.mag()/2)*2;
      w.normalize();
      PVector uw = w.get();// store the unit vector axis
      w.mult(w2);
      PVector ruw = PVector.mult(uw, r.dot(uw));
      r.sub(ruw);// remove the component of r parallel to w
      // get a vector perpendicular to both r and w
      // which has a magnitude proportional to the rotation angle
      PVector s = PVector.mult(r.cross(w), 0.5);
      // a vector between were r started and where it's going
      PVector m = PVector.add(r, s);
      m.normalize();
      // get the component of r parallel m
      m.mult(r.dot(m));
      // step over the middle vector by a factor of 2
      r.add(PVector.mult(PVector.sub(m, r), 2));
      // r has the same magnitude as before :)
      r.add(ruw);// restore the component of r parallel to w
    }
  }
  PVector toOri(PVector r) {
    // change of coordinates from world to orientation
    PVector val = new PVector();
    val.x = r.dot(axis[0]);
    val.y = r.dot(axis[1]);
    val.z = r.dot(axis[2]);
    return val;
  }
  PVector toWorld(PVector r) {
    // change of coordinates from orientation to world
    PVector val = new PVector();
    val.x = axis[0].x * r.x + axis[1].x * r.y + axis[2].x * r.z;
    val.y = axis[0].y * r.x + axis[1].y * r.y + axis[2].y * r.z;
    val.z = axis[0].z * r.x + axis[1].z * r.y + axis[2].z * r.z;
    return val;
  }
  // notice how much shorter this one is
  // 61 lines : 114 lines = 1:2
  // thats what we call miniaturization :)
}
