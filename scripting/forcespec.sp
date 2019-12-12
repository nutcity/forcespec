#include <sourcemod>

public Plugin myinfo =
{
  name = "Force Spectate",
  author = "wolsne",
  description = "Invoke !fpsec to force all clients to the spectator team.",
  version = "0.1",
  url = "https://github.com/nutcity"
};

public void OnPluginStart()
{
  RegAdminCmd("sm_fspec", Command_Fspec, ADMFLAG_CHANGEMAP);
  LoadTranslations("common.phrases.txt"); // Required for FindTarget fail reply
}

public Action Command_Fspec(int client, int nil) //2nd Arg un-needed
{
  char arg1[32];

  GetCmdArg(1, arg1, sizeof(arg1));

  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  if ((target_count = ProcessTargetString(
    arg1,
    client,
    target_list,
    MAXPLAYERS,
    0, /*Allow all connected players to be targered*/
    target_name,
    sizeof(target_name),
    tn_is_ml)) <=0)
  {
    ReplyToTargetError(client, target_count);
    return Plugin_Handled;
  }

  for (int i = 0; i < target_count; i++)
  {
    ChangeClientTeam(target_list[i], 1);
    LogAction(client, target_list[i], "\"%L\" forced \"%L to spectator.", client, target_list[i]);
  }
  if (tn_is_ml)
  {
    ShowActivity2(client, "[SM] ", "Forced %t to spectator.", target_name);
  }
  else
  {
    ShowActivity2(client, "[SM] ", "Forced %t to spectator.", target_name);
  }

  return Plugin_Handled;
}
