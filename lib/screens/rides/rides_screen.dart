import 'package:flutter/material.dart';

import '../../model/ride/ride.dart';
import '../../model/ride_pref/ride_pref.dart';
import '../../service/ride_prefs_service.dart';
import '../../service/rides_service.dart';
import '../../theme/theme.dart';

import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  //RidePreference currentPreference  = fakeRidePrefs[0];   // TODO 1 :  We should get it from the service
   RidePreference? currentPreference = RidePrefService.instance.currentPreference;


  @override
  void initState() {
    super.initState();
    currentPreference = RidePrefService.instance.currentPreference!;
  }

  ////
  List<Ride> get matchingRides {
    return RidesService.instance
        .getRides(currentPreference!, null);
  }
  void onBackPressed() {
    Navigator.of(context).pop(); //  Back to the previous view
  }

  void onPreferencePressed() async {
    // TODO  6 : we should push the modal with the current pref
    final newPreference = await showModalBottomSheet<RidePreference>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RidePrefModal(currentPreference: currentPreference!);
      },
    );

    // TODO 9 :  After pop, we should get the new current pref from the modal

    // TODO 10 :  Then we should update the service current pref,   and update the view

    RidePrefService.instance.addPreference(newPreference!);
    setState(() {
      currentPreference = newPreference;
    });
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference!,
              onBackPressed: onBackPressed,
              onPreferencePressed: onPreferencePressed,
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder:
                    (ctx, index) =>
                        RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
