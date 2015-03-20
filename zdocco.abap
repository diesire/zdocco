*! # zdocco
*!
*! Quick and dirty documentatation generator
*&---------------------------------------------------------------------*
*& Report  ZDOCCO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zdocco.

field-symbols:
  <gs_input> type string.

data:
  gt_input type string_t,
  gt_output type string_t,
  gs_line type string,
  gv_code_open type xfeld.

*! ## Inicio
start-of-selection.

* Read report
  read report 'ZDOCCO' into gt_input.

*! Loop source. If starts with `*!` treat as markdown
*! else trat as code
  loop at gt_input assigning <gs_input>.
    if <gs_input> is not initial
      and <gs_input>+0(2) = '*!'.
      if gv_code_open = abap_true.
        gv_code_open = abap_false.
        gs_line = '````'.
        append gs_line to gt_output.

        gs_line = ''.
        append gs_line to gt_output.
      endif.

      gs_line = <gs_input>.
      shift gs_line left by 3 places.

      append gs_line to gt_output.
    else.
      if gv_code_open = abap_false.
        gv_code_open = abap_true.
        gs_line = ''.
        append gs_line to gt_output.

        gs_line = '````abap'.
        append gs_line to gt_output.
      endif.

      gs_line = <gs_input>.
      append gs_line to gt_output.
    endif.
  endloop.

* If open, close code
  if gv_code_open = abap_true.
    gv_code_open = abap_false.
    gs_line = '````'.
    append gs_line to gt_output.
    gs_line = ''.
    append gs_line to gt_output.
  endif.

***********************************************************************
  call function 'GUI_DOWNLOAD'
    exporting
      filename                = 'C:/tmp/zdocco.md'
      codepage                = '4110'
    tables
      data_tab                = gt_output
    exceptions
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      others                  = 22.

  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.