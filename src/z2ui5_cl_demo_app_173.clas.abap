CLASS z2ui5_cl_demo_app_173 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        DATE type string,
        AGE  type string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        FNAME      type string,
        merge      TYPE string,
        visible    TYPE string,
        binding    type string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_173 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    DATA temp1 TYPE z2ui5_cl_demo_app_173=>ty_t_data.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_demo_app_173=>ty_t_layout.
    DATA temp4 LIKE LINE OF temp3.
    DATA view TYPE REF TO z2ui5_cl_xml_view.

    client->_bind( mt_layout ).

    
    CLEAR temp1.
    
    temp2-name = 'Theo'.
    temp2-date = '01.01.2000'.
    temp2-age = '5'.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = 'Lore'.
    temp2-date = '01.01.2000'.
    temp2-age = '1'.
    INSERT temp2 INTO TABLE temp1.
    mt_data = temp1.

    
    CLEAR temp3.
    
    temp4-fname = 'NAME'.
    temp4-merge = 'false'.
    temp4-visible = 'true'.
    temp4-binding = '{NAME}'.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = 'DATE'.
    temp4-merge = 'false'.
    temp4-visible = 'true'.
    temp4-binding = '{DATE}'.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = 'AGE'.
    temp4-merge = 'false'.
    temp4-visible = 'false'.
    temp4-binding = '{AGE}'.
    INSERT temp4 INTO TABLE temp3.
    mt_layout = temp3.

    
    view = z2ui5_cl_xml_view=>factory( ).

    view->shell( )->page(
    )->table( items = client->_bind( mt_data )
      )->columns(
        )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO`
          )->column( mergeduplicates = `{LO>MERGE}` visible = `{LO>VISIBLE}` )->get_parent(
        )->get_parent( )->get_parent(
        )->items(
          )->column_list_item(
            )->cells(
              )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO2`
                )->object_identifier( text = `{LO2>BINDING}` ).

     client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
