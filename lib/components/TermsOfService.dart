import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 800,
        child: Column(
          children: [
            // header
            Container(
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text("利用規約",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ))),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ])),
            // body
            Container(
                height: 740,
                color: CommonColor.primaryColor[100],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("第1条（適用）",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        "本規約は，ユーザーと運営との間の本サービスの利用に関わる一切の関係に適用されるものとします。本規約の規定が前条の個別規定の規定と矛盾する場合には，個別規定において特段の定めなき限り，個別規定の規定が優先されるものとします。",
                        overflow: TextOverflow.clip,
                      ),
                      Text("第2条（利用登録）",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        "本サービスにおいては，登録希望者が本規約に同意の上，運営の定める方法によって利用登録を申請し，運営がこの承認を登録希望者に通知することによって，利用登録が完了するものとします。",
                        overflow: TextOverflow.clip,
                      ),
                      Text("第3条（ユーザーIDおよびパスワードの管理）",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        "ユーザーは，自己の責任において，本サービスのユーザーIDおよびパスワードを適切に管理するものとします。ユーザーは，いかなる場合にも，ユーザーIDおよびパスワードを第三者に譲渡または貸与し，もしくは第三者と共用することはできません。運営は，ユーザーIDとパスワードの組み合わせが登録情報と一致してログインされた場合には，そのユーザーIDを登録しているユーザー自身による利用とみなします。",
                        overflow: TextOverflow.clip,
                      ),
                      Text("第4条（禁止事項）",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        "ユーザーは，本サービスの利用にあたり，法令または公序良俗に違反する行為、犯罪行為に関連する行為、他のユーザーに関する個人情報等を収集または蓄積する行為、サービスの運営を妨害するおそれのある行為をしてはなりません",
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        "運営は、ユーザーが禁止行為を行った場合には，事前の通知なく，投稿データを削除し，ユーザーに対して本サービスの全部もしくは一部の利用を制限しまたはユーザーとしての登録を抹消することができるものとします。",
                        overflow: TextOverflow.clip,
                      ),
                      Text("第5条（著作権）",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        "ユーザーは，自ら著作権等の必要な知的財産権を有するか，または必要な権利者の許諾を得た文章，画像や映像等の情報に関してのみ，本サービスを利用し，投稿ないしアップロードすることができるものとします",
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
