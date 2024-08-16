class Apiservice {
  static String login = 'auth/prpd_login';
  static String check_balance = 'lmoprepaid/chckblncelmo';
  static String inventorycnt = 'inventory/getInvntryTtlCnt';
  static String cpedata = 'inventory/getInvntrySplrsCnt';
  static String renewdata = 'olt/suspended/cafs_with_srvr_pgntn';
  static String renewcafdata = 'lmoprepaid/renewcafdata/';
  static String package_wise_data = 'lmoprepaid/pckgewisedata/';
  static String BoxExchange = 'olt/boxchange_with_srvr_pgntn';
  static String renew_api = 'caf_operations/prepaid_resume_version';
  static String enterprise_cafrenew = 'caf_operations/resume';

  static String pon_change = 'olt/get/ponChange_with_srvr_pgntn';
  static String pon_chng_refresh = 'olt/ponchangeCaf/';
  static String box_details = 'caf/boxdtls/';
  static String box_chng_submit = 'caf_operations/box-change';
  static String double_box_chng = 'caf_operations/double-box-change';
  static String box_change_refresh = 'olt/boxchangeCaf/';

  static String agent_district_list = 'agent/agnt_dstrctList';
  static String agent_mndl_list = 'agent/agnt_mandalList/';
  static String agent_vlg_list = 'agent/agnt_vlgeList/';
  static String oltdetails = 'olt/oltdetails/';
  static String olt_slots_details = 'olt/slotDetails/';
  static String olt_slot_details_for_port = 'olt/slotDetailsForPort';

  static String olt_slot_two_details_for_port = 'olt/slottwoDetailsForPort';
  static String olt_slot_three_details_for_port = 'olt/slotthreeDetailsForPort';

  static String pon_chng_submit = 'caf_operations/pon-change';
  static String validation_split_data = 'olt/validation/splitsData';
  static String split_data = 'olt/spiltsData';

  static String termination_data = 'caf/terminated/cafs';
  static String cancel_termination_req = 'caf/rejectTermination';
  static String add_termination_cafs_list = 'caf/getAgntCafDetailsWthLmtCndtn';
  static String termination_submit_api = 'caf/agent/terminated/cafs';

  static String subscriber_otp_verification = 'caf/getOTPPndngVrfdList/';

  static String revenue_sharing = 'olt/newprepaid_revenueShaing/year/';

  static String payment_sharing = 'lmoprepaid/faccountingledger';

  static String mtd_revenue = 'lmoprepaid/apsflmnthtdyrev';
  static String all_caf_cnt = 'lmoprepaid/allcafcountin';
  static String mtd_online_clctn = 'lmoprepaid/apsflmnthtdyclctn';
  static String mtd_renewed_cafs = 'lmoprepaid/mnthtdyrenewcaf';
  static String expiry_cafs = 'lmoprepaid/expcafsumthreendfiveday';

  // Notification APIs
  static String notification = 'lmoprepaid/getnotificationdata';
  static String notification_update = 'lmoprepaid/updatenotificationdata';

  // BUlk Renewal API
  static String bulk_renewal_list = 'caf_operations/bulk_cafs_with_srvr_pgntn';
  static String bulk_renewal_submit = 'caf_operations/bulk-resume';

  // Advance Bulk Renewal API
  static String advance_bulk_renewal_submit =
      'caf_operations/bulk-advance-resume';
  static String advance_bulk_renewal_list =
      'caf_operations/advance_bulk_cafs_with_srvr_pgntn';

  // Package change API
  static String package_change_submit = 'caf/getAgntCafDetailsWthLmtCndtn';
  static String package_details = 'caf/getAgntCafDetailsWthLmtCndtn';

  // Pon Connection Status API
  static String pon_connection_status = 'olt/getAgntPonCounts';
  static String pon_connection_allocated_caf = 'olt/getAgntPonAssgnedCaf';

  // Add On Package API
  static String add_on_package_list = 'package/packages/addons/hsi';
  static String add_on_package_submit = 'package/addHSICafPckgs_newversion';
  static String add_on_package_channels = 'package/packages/addons/channels';
  static String add_on_package_channels_local =
      'package/packages/addons/localChannels';
  static String add_on_package_get_cstmrdtls = 'package/getCafCstmrDtls';
  static String add_on_package_get_cafs = 'package/getChannels';

  // Monthly Collection API
  static String monthly_collection_list = 'olt/prepaid_mnthlyCollections';

  // Search Cafs
  static String total_search_caf = 'caf/getTotalAgentCafCnts';
  static String list_search_caf = 'caf/getAgntCafDetailsWthLmtCndtn';
  static String customer_details_profile = 'caf/customer/profile/';
  static String customer_details_names = 'caf/getCustomerNewSegmntDta';
  static String customer_details_ont = 'ont/details/';
  static String customer_details_package =
      'caf/getCustomerNewSlctdSegmntDta/1/';
  static String customer_details_voipusage =
      'caf/getCustomerNewSlctdSegmntDta/2/';
  static String customer_details_hsiusage =
      'caf/getCustomerNewSlctdSegmntDta/3/';
  static String customer_details_invoiceusage =
      'caf/getCustomerNewSlctdSegmntDta/4/';

  // Enterprise Cafs
  static String list_enterprise_caf = 'caf/entcaf/';
  static String list_department_names = 'crm/entDepartmentNames';
}
