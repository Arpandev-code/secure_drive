import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StorageContainer extends StatelessWidget {
  const StorageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(10, 10),
              blurRadius: 20,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(-10, -10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            circularProgressIndicator(
              context: context,
              value: 35.0,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Row(
                  children: [
                    ColoredBox(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 10,
                        width: 10,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(children: [
                      Text(
                        "Used",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "35 GB",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
                  ],
                ),
                Row(
                  children: [
                    ColoredBox(
                      color: Colors.grey.shade400,
                      child: const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Column(children: [
                      Text(
                        "Free",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "100 GB",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
                  ],
                )
              ],
            )
          ]),
        ));
  }

  Widget circularProgressIndicator({
    required BuildContext context,
    required double value,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.6,
            axisLineStyle: AxisLineStyle(
              thickness: 0.15,
              thicknessUnit: GaugeSizeUnit.factor,
              color: Colors.grey.withOpacity(0.2),
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: value,
                width: 0.15,
                color: Colors.orange,
                pointerOffset: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${value.toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const Text(
                      'Used',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                positionFactor: 0.1,
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
