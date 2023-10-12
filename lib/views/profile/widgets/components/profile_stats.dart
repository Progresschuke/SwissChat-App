import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.heading,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String? heading;
  final String? title;
  final IconData? icon;
  final String? subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 0.02 * size.height, horizontal: 0.05 * size.width),
      child: ListTile(
        leading: Icon(icon),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 0.005 * size.height,
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    title!,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                ),
              ],
            ),
            IconButton(onPressed: onTap, icon: const Icon(Icons.edit))
          ],
        ),
        subtitle: Text(
          subtitle!,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
        ),
      ),
    );
  }
}
