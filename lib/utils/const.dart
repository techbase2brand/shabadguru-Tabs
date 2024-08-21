const normalLyric = """[ti:If I Didn't Love You]
[ar:Jason Aldean/Carrie Underwood]
[al:If I Didn't Love You]
[by:]
[offset:0]
[00:00.45]If I Didn't Love You - Jason Aldean/Carrie Underwood
[00:02.49]
[00:11.15]I wouldn't mind being alone
[00:12.85]
[00:13.68]I wouldn't keep checking my phone
[00:16.29]Wouldn't take the long way home
[00:18.00]Just to drive myself crazy
[00:20.56]
[00:21.53]I wouldn't be losing sleep
[00:23.27]
[00:24.24]Remembering everything
[00:26.57]Everything you said to me
[00:28.62]Like I'm doing lately
[00:31.10]You you wouldn't be all
[00:34.55]
[00:35.34]All that I want
[00:37.08]
[00:37.82]Baby I can let go
[00:39.45]
[00:40.36]If I didn't love you I'd be good by now
[00:45.28]I'd be better than barely getting by somehow
[00:49.81]
[00:50.77]Yeah it would be easy not to miss you
[00:54.57]Wonder about who's with you
[00:57.20]Turn the want you off
[00:58.61]Whenever I want to
[01:01.21]If I didn't love you
[01:05.26]
[01:06.32]If I didn't love you
[01:09.33]
[01:13.71]I wouldn't still cry sometimes
[01:15.86]
[01:16.51]Wouldn't have to fake a smile
[01:18.26]
[01:18.83]Play it off and tell a lie
[01:20.97]When somebody asked how I've been
[01:24.17]I'd try to find someone new
[01:25.70]Someone new
[01:26.82]It should be something I can do
[01:28.53]I can do
[01:29.37]Baby if it weren't for you
[01:31.22]I wouldn't be in the state that I'm in
[01:33.78]Yeah you
[01:34.37]
[01:35.17]You wouldn't be all
[01:37.10]
[01:37.99]All that I want
[01:39.62]
[01:40.41]Baby I could let go
[01:42.98]If I didn't love you I'd be good by now
[01:47.85]I'd be better than barely getting by somehow
[01:52.47]
[01:53.42]Yeah it would be easy not to miss you
[01:57.14]Wonder about who's with you
[01:59.75]Turn the want you off
[02:01.06]Whenever I want to
[02:03.30]
[02:03.82]If I didn't love you
[02:07.87]
[02:08.91]If I didn't love you
[02:11.08]Oh if I didn't love you
[02:14.59]It wouldn't be so hard to see you
[02:18.05]Know how much I need you
[02:20.68]Wouldn't hate that I still feel like I do
[02:24.26]
[02:24.77]If I didn't love you
[02:26.70]Oh if I didn't love you
[02:30.14]If I didn't love you
[02:32.77]Hmm mm-hmm
[02:34.57]
[02:35.09]If I didn't love you I'd be good by now
[02:39.96]I'd be better than barely getting by somehow
[02:44.88]
[02:45.56]Yeah it would be easy not to miss you
[02:49.33]Wonder about who's with you
[02:51.96]Turn the want you off
[02:53.24]Whenever I want to
[02:56.04]If I didn't love you
[02:59.32]Yeah ayy ayy
[03:01.21]If I didn't love you
[03:03.28]Oh if I didn't love you
[03:06.56]If I didn't love you
[03:09.07]If I didn't love you
[03:11.67]If I didn't love you""";

const transLyric = """[ti:If I Didn't Love You]
[ar:Jason Aldean/Carrie Underwood]
[al:If I Didn't Love You]
[by:]
[offset:0]
[00:00.45]腾讯音乐享有本翻译作品的著作权
[00:02.49]
[00:11.15]我不介意孤身一人
[00:12.85]
[00:13.68]我不会一直查看我手机
[00:16.29]我不会兜远路回家
[00:18.00]只为让自己陷入疯狂中
[00:20.56]
[00:21.53]我也不会辗转反侧
[00:23.27]
[00:24.24]回忆起你对我
[00:26.57]说的每字每句
[00:28.62]最近我如这般
[00:31.10]你不会是
[00:34.55]
[00:35.34]我渴望的所有
[00:37.08]
[00:37.82]宝贝我能放下所有
[00:39.45]
[00:40.36]如果我从未爱上你 此刻的我不会如此伤心
[00:45.28]我会过得比现在好 现在的我像行尸走肉般
[00:49.81]
[00:50.77]或许不去想你会让我好受点
[00:54.57]不去想谁在你身边
[00:57.20]想切断对你的思念
[00:58.61]无论何时
[01:01.21]如果我从未爱上你
[01:05.26]
[01:06.32]如果我从未爱上你
[01:09.33]
[01:13.71]我就不会有时仍会淌泪
[01:15.86]
[01:16.51]不必佯装笑颜
[01:18.26]
[01:18.83]当某人问起我近况
[01:20.97]我会敷衍了事
[01:24.17]我试着去另觅新欢
[01:25.70]另觅新欢
[01:26.82]我本应做得到
[01:28.53]能够做到
[01:29.37]宝贝若不是因为你
[01:31.22]我就不会落得如此下场
[01:33.78]没错是你
[01:34.37]
[01:35.17]你不会是
[01:37.10]
[01:37.99]我渴望的所有
[01:39.62]
[01:40.41]宝贝我能放下所有
[01:42.98]如果我从未爱上你 此刻的我不会如此伤心
[01:47.85]我会过得比现在好 现在的我像行尸走肉般
[01:52.47]
[01:53.42]或许不去想你会让我好受点
[01:57.14]不去想谁在你身边
[01:59.75]想切断对你的思念
[02:01.06]无论何时
[02:03.30]
[02:03.82]如果我从未爱上你
[02:07.87]
[02:08.91]如果我从未爱上你
[02:11.08]如果我从未爱上你
[02:14.59]看见你时我就不会如此难受
[02:18.05]你知道我有多需要你吗
[02:20.68]我就不会恨自己仍对你保留感觉
[02:24.26]
[02:24.77]如果我从未爱上你
[02:26.70]如果我从未爱上你
[02:30.14]如果我从未爱上你
[02:32.77]//
[02:34.57]
[02:35.09]如果我从未爱上你 此刻的我不会如此伤心
[02:39.96]我会过得比现在好 现在的我像行尸走肉般
[02:44.88]
[02:45.56]或许不去想你会让我好受点
[02:49.33]不去想谁在你身边
[02:51.96]想切断对你的思念
[02:53.24]无论何时
[02:56.04]如果我从未爱上你
[02:59.32]//
[03:01.21]如果我从未爱上你
[03:03.28]如果我从未爱上你
[03:06.56]如果我从未爱上你
[03:09.07]如果我从未爱上你
[03:11.67]如果我从未爱上你""";