import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeleponItem extends StatelessWidget {
  final String nama, alamat, nomor;

  TeleponItem({
    required this.nama,
    required this.alamat,
    required this.nomor,
  });

  @override
  Widget build(BuildContext context) {
    final Uri _phoneCall = Uri(scheme: 'tel', path: nomor);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 13, 10, 16),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        alamat ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    print('launching' + _phoneCall.toString());
                    launch(_phoneCall.toString());
                  },
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.orange, borderRadius: BorderRadius.circular(6)),
              child: SelectableText(
                nomor,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
