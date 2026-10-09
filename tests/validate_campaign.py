from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
CAMPAIGN = ROOT / "42/media/lua/shared/ProjectEvil/PECampaign.lua"
HUD = ROOT / "42/media/lua/client/ProjectEvil/PEHUD.lua"
MOD_INFO = ROOT / "42/mod.info"


class CampaignStructureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.campaign = CAMPAIGN.read_text(encoding="utf-8")
        cls.hud = HUD.read_text(encoding="utf-8")
        cls.mod_info = MOD_INFO.read_text(encoding="utf-8")

    def test_mod_metadata_exists(self):
        self.assertIn("id=ProjectEvil", self.mod_info)
        self.assertIn("name=Project Evil", self.mod_info)

    def test_mission_state_is_saved_in_player_mod_data(self):
        self.assertIn("md.PECampaign", self.campaign)
        self.assertIn("missionId = Campaign.MISSION_ID", self.campaign)
        self.assertIn("d.completed", self.campaign)

    def test_opening_objectives_and_completion_are_defined(self):
        for phrase in ("Investigate the village", "Scavenge food", "Hold your ground"):
            self.assertIn(phrase, self.campaign)
        self.assertIn("d.nearbyKills >= 5", self.campaign)

    def test_opening_uses_game_time_not_frame_count(self):
        self.assertIn("getWorldAgeHours()", self.campaign)
        self.assertNotIn("elapsedTicks", self.campaign)

    def test_hud_reads_campaign_state(self):
        self.assertIn("ProjectEvil.Campaign.getState(player)", self.hud)
        self.assertIn("ProjectEvil.Campaign.getObjective(player)", self.hud)


if __name__ == "__main__":
    unittest.main()
